# Local audio configuration

`audio-scarlett` reads device selectors from
`${XDG_CONFIG_HOME:-$HOME/.config}/audio-scarlett.conf`. This file stays on the
machine and is not deployed from the repository, like `~/.localaliases`.
`AUDIO_SCARLETT_CONFIG` can select another configuration file.

The file uses shell assignment syntax:

```sh
card="YOUR_SCARLETT_CARD_NAME"
sink="YOUR_SCARLETT_SINK_NAME"
source="YOUR_MICROPHONE_SOURCE_NAME"
```

Find names with `pactl list short cards`, `pactl list short sinks`, and
`pactl list short sources`. `card` and `sink` are required. Omit `source` to
leave the current microphone selection alone. The file is sourced as shell
code, so only use configuration you maintain yourself.

The helper selects the card's pro-audio profile and output, sets output volume
to 90%, and unmutes it. It selects the configured microphone only if present.
The existing PipeWire and WirePlumber settings in this package remain
host-specific; the device serials do not belong in the shared files.
