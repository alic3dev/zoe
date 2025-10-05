# zoe

<img width="3932" height="2490" alt="zoe_menu" src="https://github.com/user-attachments/assets/2e6c4fca-96b3-46e2-82a1-7156889a50da" />

<img width="1966" height="1250" alt="zoe_forest" src="https://github.com/user-attachments/assets/bc4031e2-d408-437d-94a2-3ee51c3b4eb3" />

## requirements

- os->{`macos`}
- - version.minimum->{`15.0`};
- - - defaults:to->{`26.0`};
- - - override_with:`target_macos_version`
- - with->{`metal`}.support().version.minimum->{`2.1`};

### frameworks

- `metal`
- `metalkit`
- `gamecontroller`
- `coreaudio`
- `coregraphics`
- `coretext`

## configuration

- path->{`~/.config/zoe`};
- parameter:name->{value}
- - `audio:volume`: `float`
- - `rendering_properties:brightness`: `float`
- - `rendering_properties:brightness_text`: `float`

### example

```
audio:volume->{0.27};
```

## development

### prerequisites

- [`alic3`](https://github.com/alic3dev):libraries
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- - [`math_c`](https://github.com/alic3dev/math_c)
- - [`metil`](https://github.com/alic3dev/metil)

### assets

```zsh
make pull_assets
```

#### redownload

```zsh
make pull_assets_all
```

### build

```zsh
make
```

#### options

- `debug=1`:adds->{`debugging_symbols`}:disables->{`optimizations`};
- `disable_metal_fast_options=1`:disables->{`metal`::`fast_modes `};
- `target_macos_version`:sets_the_target_version.for->{`macos`|`metal`};

```zsh
parameter=value make
: or
parameter_1=value_1 parameter_2=value_2 make
```

### clean

```zsh
make clean
```

## copyright | copyleft

> © [copyleft|copyright]->{alic3dev:2025}->[all_rights_reserved|all_lefts_reserved]
