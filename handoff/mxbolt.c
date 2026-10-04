// mxbolt - switch a Logitech Easy-Switch device to another host through a
// Bolt/Unifying receiver, using HID++ 2.0 ChangeHost (0x1814).
//
//   mxbolt              report host count and current slot
//   mxbolt <1|2|3>      switch to host slot (as labelled on the device)
//   mxbolt -d <n> ...   address receiver device index n (default 1)
//   mxbolt -q ...       no output, exit code only
//
// Goes through the receiver rather than a directly Bluetooth-connected mouse:
// macOS refuses to open a BLE mouse's vendor HID collection, so HID++ over BLE
// is unreachable, while the receiver's collection opens with no permissions.
#include <hidapi/hidapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define LOGI_VID        0x046D
#define HIDPP_LONG      0x11
#define HIDPP_LONG_LEN  20
#define SW_ID           0x0E
#define ERR_BYTE        0x8F
#define FEAT_CHANGEHOST 0x1814

static unsigned char g_idx = 0x01;
static int g_quiet;

static const unsigned short RECEIVER_PIDS[] = { 0xC548, 0xC52B, 0xC532, 0xC539, 0xC53F, 0 };

static const char *hidppError(unsigned char c) {
    switch (c) {
        case 0x04: return "CONNECT_FAIL - urzadzenie niepolaczone z odbiornikiem";
        case 0x07: return "BUSY";
        case 0x08: return "UNKNOWN_DEVICE";
        case 0x09: return "RESOURCE_ERROR - pusty slot";
        case 0x0A: return "REQUEST_UNAVAILABLE";
        default:   return "nieznany kod";
    }
}

static double now(void) {
    struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

static int sendMsg(hid_device *h, unsigned char feat, unsigned char func,
                   const unsigned char *params, int nparams) {
    unsigned char m[HIDPP_LONG_LEN];
    memset(m, 0, sizeof(m));
    m[0] = HIDPP_LONG;
    m[1] = g_idx;
    m[2] = feat;
    m[3] = func;
    for (int i = 0; i < nparams && 4 + i < HIDPP_LONG_LEN; i++) m[4 + i] = params[i];
    return hid_write(h, m, HIDPP_LONG_LEN);
}

// Returns payload length, or 0 on timeout. Reply lands in out[].
static int readReply(hid_device *h, unsigned char *out, int outlen, double timeout) {
    double end = now() + timeout;
    while (now() < end) {
        unsigned char buf[64];
        int n = hid_read(h, buf, sizeof(buf));
        if (n >= 4 && buf[1] == g_idx) {
            int c = n < outlen ? n : outlen;
            memcpy(out, buf, (size_t)c);
            return c;
        }
        if (n <= 0) { struct timespec t = {0, 5000000}; nanosleep(&t, NULL); }
    }
    return 0;
}

static int exchange(hid_device *h, unsigned char feat, unsigned char func,
                    const unsigned char *params, int nparams,
                    unsigned char *out, int outlen, double timeout) {
    if (sendMsg(h, feat, func, params, nparams) < 0) return -1;
    if (timeout <= 0) return 0;
    return readReply(h, out, outlen, timeout);
}

int main(int argc, char **argv) {
    int target = -1;
    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-d") && i + 1 < argc) g_idx = (unsigned char)atoi(argv[++i]);
        else if (!strcmp(argv[i], "-q")) g_quiet = 1;
        else target = atoi(argv[i]) - 1;   // 1-based on the command line
    }

    if (hid_init()) { fprintf(stderr, "hid_init nieudane\n"); return 1; }

    char path[512] = {0};
    for (int p = 0; RECEIVER_PIDS[p] && !path[0]; p++) {
        struct hid_device_info *devs = hid_enumerate(LOGI_VID, RECEIVER_PIDS[p]);
        for (struct hid_device_info *d = devs; d; d = d->next) {
            // HID++ long messages ride the vendor collection usage 0x0002.
            if (d->usage_page == 0xFF00 && d->usage == 0x0002) {
                snprintf(path, sizeof(path), "%s", d->path);
                break;
            }
        }
        hid_free_enumeration(devs);
    }
    if (!path[0]) { fprintf(stderr, "Nie znaleziono odbiornika Logitech\n"); return 1; }

    hid_device *h = hid_open_path(path);
    if (!h) { fprintf(stderr, "Nie moge otworzyc odbiornika\n"); return 2; }
    hid_set_nonblocking(h, 1);

    unsigned char rx[64];
    unsigned char fp[2] = { (FEAT_CHANGEHOST >> 8) & 0xFF, FEAT_CHANGEHOST & 0xFF };
    int n = exchange(h, 0x00, (0x00 << 4) | SW_ID, fp, 2, rx, sizeof(rx), 2.0);
    if (n <= 0) { fprintf(stderr, "Brak odpowiedzi od urzadzenia %u\n", g_idx); return 3; }
    if (rx[2] == ERR_BYTE) {
        fprintf(stderr, "HID++ 0x%02X: %s\n", rx[5], hidppError(rx[5]));
        return 4;
    }
    unsigned char chi = rx[4];
    if (!chi) { fprintf(stderr, "Urzadzenie nie wspiera ChangeHost\n"); return 5; }

    n = exchange(h, chi, (0x00 << 4) | SW_ID, NULL, 0, rx, sizeof(rx), 2.0);
    if (!g_quiet && n > 0 && rx[2] != ERR_BYTE)
        printf("hostow=%u  aktualny=%u  (slot %u)\n", rx[4], rx[5], rx[5] + 1);

    if (target < 0) { hid_close(h); hid_exit(); return 0; }
    if (target > 15) { fprintf(stderr, "Slot poza zakresem\n"); return 6; }

    unsigned char t = (unsigned char)target;
    sendMsg(h, chi, (0x01 << 4) | SW_ID, &t, 1);   // no reply: device drops instantly
    if (!g_quiet) printf("-> slot %d\n", target + 1);
    hid_close(h);
    hid_exit();
    return 0;
}
