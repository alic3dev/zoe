# zoe

<img width="640" height="407" alt="Screenshot 2025-11-08 at 00 48 28 Large" src="https://github.com/user-attachments/assets/4a93ee4c-b882-462d-94ee-b53905c0b5a9" />
<img width="160" height="102" alt="Screenshot 2025-11-08 at 00 48 28 Small" src="https://github.com/user-attachments/assets/482a4469-b701-4121-ad95-b137e2ebcc65" />
<img width="1966" height="1250" alt="Screenshot 2025-11-08 at 00 48 38" src="https://github.com/user-attachments/assets/fd992cbd-2caa-4428-b0df-412c1b7610c0" />
<img width="1966" height="1250" alt="Screenshot 2025-11-08 at 00 48 32" src="https://github.com/user-attachments/assets/0785ad7a-eccd-42e1-87b9-df66b5f3e2d2" />

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
