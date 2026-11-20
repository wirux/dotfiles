# workstation-handoff

Hand a two-Mac desk over from one machine to the other: the Glove80 switches its
own Bluetooth profile, and a sentinel keycode makes the mouse follow.

```
Glove80 macro ──F19/F20──► Karabiner ──► mxbolt ──HID++──► MX Master 3S
Glove80 key   ──F13-F16──► Karabiner ──► mon    ──DDC───► P3425WE / U3824DW
```

The two rows are deliberately independent. Monitors are not tied to the mouse
and keyboard: moving one picture across the desk while the keyboard stays put is
the common case, and coupling them would make that impossible.

## Build

```sh
make && make install        # -> ~/.local/bin/mxbolt
```

Needs `hidapi` (`brew install hidapi`) and Xcode command line tools.

## mxbolt

```sh
mxbolt            # hostow=3  aktualny=2  (slot 3)
mxbolt 1          # switch the mouse to slot 1
mxbolt -q 3       # ... quietly, exit code only
mxbolt -d 2       # address receiver device index 2 (default 1)
```

Slot numbers are 1-based, matching the labels on the device.

## mon

```sh
mon private              # both monitors to this Mac
mon company              # both monitors to the company Mac
mon top company          # one monitor, absolute
mon toggle bottom        # one monitor, relative to where it is now
mon status               # where each monitor currently is
```

Monitors are addressed by **role**, never by model or m1ddc index, so the input
table lives in exactly one place — the top of the script:

| role     | model    | private      | company      |
| -------- | -------- | ------------ | ------------ |
| `top`    | P3425WE  | `27` USB-C   | `15` DP      |
| `bottom` | U3824DW  | `15` DP      | `27` USB-C   |

Note the table is mirrored: each Mac reaches one monitor over USB-C and the
other over DP.

`mon` is **not installed anywhere** — Karabiner and the Stream Deck bundles call
`~/.config/handoff/bin/mon` directly. It is a script, so there is nothing to
build, and a copy in `~/.local/bin` would only be a second version to forget to
update. `mxbolt` is installed because a compiled binary cannot be run from where
its source lives.

On a machine that only drives monitors there is nothing to install at all: clone
this repo and point Karabiner at the script. No compiler, no hidapi.

## Hard constraints, each established by measurement

**HID++ over Bluetooth is unreachable on macOS.** A BLE mouse exposes its HID++
endpoint on a separate top-level collection (usage page `0xFF43`) that macOS
refuses to open — `IOHIDDeviceOpen` returns `kIOReturnNotPermitted` even as
root, and Input Monitoring does not help because TCC attributes the permission
to the *responsible process*, not the binary. Eight framing combinations were
tried, with Logi Options+ both running and stopped: every one either returned
`kIOReturnNotFound` or silence.

Everything therefore goes **through the Bolt receiver**, whose HID++ collection
opens with no permissions at all.

**Switching is one-way.** `ChangeHost` is a command sent *to* the device, so it
needs a live radio link. A machine can push the mouse away but can never pull it
back — once the mouse is on another host, this receiver reports `CONNECT_FAIL`.
Bringing it back is the other machine's job, driven by its own sentinel. This is
why a daemon is needed on both Macs; it is not a design choice.

**The sentinel must be tapped before the profile switch**, not after, so it is
delivered to the host being left while the link is still up. The macro that does
this lives in the Glove80's own keymap repo; `macro_wait_time` is the slack for
delivering the HID report before the BLE link drops - raise it if the key is
occasionally lost.

## Karabiner

The rules already live in this repo, in `../karabiner/karabiner.json` — look for
the `Glove80:` complex modifications. The sentinel table is the contract between
this repo and the keymap repo; change it in both or not at all:

| sentinel | runs                 | effect                        |
| -------- | -------------------- | ----------------------------- |
| `F13`    | `mon company`        | both monitors to company Mac  |
| `F14`    | `mon private`        | both monitors to this Mac     |
| `F15`    | `mon toggle top`     | flip P3425WE                  |
| `F16`    | `mon toggle bottom`  | flip U3824DW                  |
| `F19`    | `mxbolt -q 1`        | mouse to company Mac          |
| `F20`    | `mxbolt -q 3`        | mouse to this Mac             |

Only F19/F20 are tapped from a macro that also switches the Bluetooth profile,
because only they hand the keyboard over. F13-F16 are plain `&kp` — nothing
leaves, so there is no window to beat.

Note that adding a rule through the UI
*copies* it out of `assets/complex_modifications/`, so editing an asset file
afterwards has no effect on the running config; edit `karabiner.json` itself.

Two things that cost hours and will do so again:

- **The keyboard must not be ignored.** Karabiner only manipulates devices
  enabled in its Devices tab. The Glove80 (`0x16C0:0x27DB`) was marked
  `ignore: true`, so no rule applied to it — while Karabiner-EventViewer still
  showed the keypresses, because it observes raw events before filtering. If a
  rule silently does nothing, check this first.
- **`modifiers.optional: ["any"]`** is required. The macro lives on a layer, so a
  modifier may be held when the sentinel fires; without `optional`, the rule
  matches only when no modifier is down.

Karabiner runs `shell_command` in a minimal environment — use absolute paths,
never `$HOME`.

## Desk wiring

```
U3824DW   DP    <- private Mac        USB-C <- company Mac (its base)
P3425WE   USB-C <- private Mac (base) DP    <- company Mac
```

Each monitor's USB hub belongs to whichever machine holds its USB-C input, so
**the Bolt receiver must sit in the P3425WE hub** — in the U3824DW hub it would
travel to the company Mac and this machine would lose its link to the mouse.

## Monitors over DDC

Driven by `mon`, see above (`brew install m1ddc`):

```sh
m1ddc display <id> set input 15     # DP
m1ddc display <id> set input 27     # USB-C
m1ddc display <id> set input 17     # HDMI1       (18 = HDMI2)
m1ddc display <id> set luminance 33
```

- Address displays **by name**, never by UUID: the UUID changes whenever the
  connection path changes.
- **Verify with a read-back.** `set` reports success even when the monitor
  silently discards the command, and P3425WE corrupts roughly 2% of reads — read
  twice and require agreement.
- **A read failure is noise, not signal.** Reading a monitor parked on the other
  Mac's input works fine: 10 consecutive reads of P3425WE on the company DP input
  returned the right value 9 times and `-7` once. So `-7` means "try again", not
  "the monitor is elsewhere" — do not build state detection on it.
- Dell stores picture settings **per input**, which doubles as a reliable way to
  tell which input is active.
- No USB-C hub or dock passes DDC: seven were tested, HDMI and DisplayPort
  outputs alike, and none ever enumerated as a Thunderbolt device. Connect
  monitors directly.
- KVM switching over DDC (`m1ddc set kvm 65280`, VCP `0xE7`) works on the
  U3824DW **only while PBP is active**; at full screen the monitor rejects the
  write and the register does not change.

## Still unverified

- That the company Mac is really on P3425WE's **DP** input. The monitor accepts
  `15` and holds it without Auto Select bouncing back, which suggests a live
  signal there, but only the far side can confirm it. This replaced HDMI (`17`).
- Which slot the company Mac occupies: the mouse reports three hosts and sits on
  slot 3, but slots 1 and 2 have not been identified.
- That a second Bolt receiver on the company Mac behaves the same way. Reasonable
  to assume, not measured.
