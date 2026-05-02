name=zoe

ifndef target_device
	target_device=mac
endif

ifndef target_device_version
target_device_version=26.1
endif

ifndef target_metal_version
target_metal_version=${target_device_version}
endif

ifndef target_metal_standard
target_metal_standard=metal4.0
endif

directory_objects_base=objects
directory_output_base=output

suffix_os=
suffix_target_build=

ifeq (${target_device},mac)
target_os=macos

target_platform=arm64-apple-macos${target_device_version}
target_platform_metal=air64-apple-macos${target_metal_version}

directory_sdk=${shell xcrun --sdk macosx${target_device_version} --show-sdk-path}
endif

ifeq (${target_device},iphone)
target_os=ios
suffix_os=_ios

target_platform=arm64-apple-ios${target_device_version}
target_platform_metal=air64-apple-ios${target_macos_version_metal}

directory_sdk=${shell xcrun --sdk iphoneos${target_device_version} --show-sdk-path}
endif

directory_objects_os=${directory_objects_base}/${target_os}
directory_output_os=${directory_output_base}/${target_os}

ifeq (${debug}, 1)
target_build=debug
target_build_library=${target_build}
suffix_target_build=_debug
name:=${name}_${target_build}
else
ifeq (${release}, 1)
target_build=release
target_build_library=${target_build}
else
target_build=development
target_build_library=release
name:=${name}_${target_build}
endif
endif

directory_objects=${directory_objects_os}/${target_build}
directory_output=${directory_output_os}/${target_build}

directory_metal=metal

directory_air_base=air
directory_metalar_base=metalar

directory_air=${directory_air_base}/${target_os}
directory_metalar=${directory_metalar_base}/${target_os}

ifeq (${target_os},macos)
directory_app=${directory_output}/${name}.app
directory_app_contents=${directory_app}/Contents
directory_app_contents_macos=${directory_app_contents}/MacOS
directory_app_contents_resources=${directory_app_contents}/Resources
directory_output_info_plist=${directory_app_contents}
directory_output_metal=${directory_app_contents_resources}
directory_output_storyboards=${directory_app_contents_resources}
directory_output_textures=${directory_app_contents_resources}/textures
else
directory_output=${directory_output_os}/development/${name}.app
directory_output_info_plist=${directory_output}
directory_output_metal=${directory_output}
directory_output_storyboards=${directory_output}
directory_output_textures=${directory_output}/textures
endif

version_target_cer0=0
version_target_clic3=0
version_target_interrupt_handler=0
version_target_math_c=0
version_target_metil=3
version_target_rand=0

directory_include=include
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_sources=sources
directory_storyboards=storyboards
directory_textures=textures

directory_cer0=../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library/${target_os}/${target_build_library}

directory_clic3=../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library/${target_os}/${target_build_library}

directory_interrupt_handler=../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library/${target_os}/${target_build_library}

directory_math_c=../math_c
directory_math_c_include=${directory_math_c}/include
directory_math_c_library=${directory_math_c}/library/${target_os}/${target_build_library}
directory_math_c_metalar=${directory_math_c}/metalar/${target_os}

directory_metil=../metil
directory_metil_include=${directory_metil}/include
directory_metil_library=${directory_metil}/library/${target_os}/${target_build_library}
directory_metil_storyboards=${directory_metil}/storyboards

directory_rand=../rand
directory_rand_include=${directory_rand}/include
directory_rand_library=${directory_rand}/library/${target_os}/${target_build_library}

suffix_library=${suffix_os}${suffix_target_build}

ifeq (${target_os},ios)
file_cer0_library=${directory_cer0_library}/cer0${suffix_library}.o
file_clic3_library=${directory_clic3_library}/clic3${suffix_library}.o
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler${suffix_library}.o
file_math_c_library=${directory_math_c_library}/math_c${suffix_library}.o
file_metil_library=${directory_metil_library}/metil${suffix_target_build}.o
file_rand_library=${directory_rand_library}/rand${suffix_library}.o
else
file_cer0_library=${directory_cer0_library}/cer0${suffix_library}.${version_target_cer0}.dylib
file_clic3_library=${directory_clic3_library}/clic3${suffix_library}.${version_target_clic3}.dylib
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler${suffix_library}.${version_target_interrupt_handler}.dylib
file_math_c_library=${directory_math_c_library}/math_c${suffix_library}.${version_target_math_c}.dylib
file_metil_library=${directory_metil_library}/metil${suffix_library}.${version_target_metil}.dylib
file_rand_library=${directory_rand_library}/rand${suffix_library}.${version_target_rand}.dylib
endif

files_math_c_metalars=${wildcard ${directory_math_c_metalar}/*.metalar}

file_metil_metalar_metil_metal_colours=${directory_metil_library}/metil_metal_colours.metalar
file_metil_metalar_fps_display=${directory_metil_library}/metil_fps_display.metalar
file_metil_metalar_wireframe=${directory_metil_library}/metil_wireframe.metalar
file_metil_metalar_metil_metal_model_object=${directory_metil_library}/metil_metal_model.metalar

files_metil_metalars=${file_metil_metalar_metil_metal_colours} ${file_metil_metalar_fps_display} ${file_metil_metalar_wireframe} ${file_metil_metalar_metil_metal_model_object}

file_metalar=${directory_metalar}/${name}.metalar

ifeq (${target_os},macos)
file_info_plist=Info.plist
file_output=${directory_app_contents_macos}/${name}
file_output_info_plist=${directory_app_contents}/Info.plist
directory_output_metal=${directory_app_contents_resources}
file_output_metal=${directory_output_metal}/default.metallib
else
file_info_plist=Info_ios.plist
file_output=${directory_output}/${name}
file_output_info_plist=${directory_output}/Info.plist
file_output_metal=${directory_output}/default.metallib
endif

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_math_c_library} ${file_metil_library} ${file_rand_library}

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

files_metal=${shell find ${directory_metal} -name "*.metal"}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

ifeq (${target_os},macos)
files_storyboards=${directory_storyboards}/zoe.storyboard

files_storyboards_compiled=${directory_output_storyboards}/zoe.storyboardc
endif

ifeq (${target_os},ios)
files_storyboards=${directory_metil_storyboards}/metil_ios.storyboard

files_storyboards_compiled=${directory_output_storyboards}/metil_ios.storyboardc
endif

prefix_content_texture=__content_texture
prefix_content_texture_always=${prefix_content_texture}_always

files_content_textures_names=0028.png zoef.png
files_content_textures=${addprefix ${prefix_content_texture}/,${files_content_textures_names}}
files_content_textures_always=${addprefix ${prefix_content_texture_always}/,${files_content_textures_names}}

files_textures=${wildcard ${directory_textures}/*}
files_textures_resources=${patsubst ${directory_textures}/%,${directory_output_textures}/%,${files_textures}}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

ifeq (${target_os},ios)
frameworks:=${frameworks} UIKit
else
frameworks:=${frameworks} AppKit
endif

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include} -I${directory_math_c_include} -I${directory_metil_include} -I${directory_rand_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug}

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules -fconstant-cfstrings
c_flags_frameworks=${addprefix -framework ,${frameworks}}
c_flags_output=${c_flags_platform} ${c_flags_frameworks}

ifeq (${debug}, 1)
c_flags_c:=${c_flags_c} ${c_flags_debug}
c_flags_objc:=${c_flags_objc} ${c_flags_objc_debug}
c_flags_output:=${c_flags_output} ${c_flags_objc_debug}
else
c_flags_c:=${c_flags_c} -O3
c_flags_objc:=${c_flags_objc} -O3
c_flags_output:=${c_flags_output} -O3
endif

ifeq (${target_device},iphone)
c_flags_c:=${c_flags_c} -Dtarget_os_ios
c_flags_objc:=${c_flags_objc} -Dtarget_os_ios
endif

strip=strip
strip_flags=-x

metal=xcrun -sdk macosx metal
metal_ar=xcrun -sdk macosx metal-ar
metallib=xcrun -sdk macosx metallib
metal_flags_common=-target ${target_platform_metal} -std=${target_metal_standard}

ifeq (${target_os},ios)
metal_flags_common:=${metal_flags_common} -Dtarget_os_ios
endif

metal_flags=${metal_flags_common} -I${directory_include} -I${directory_math_c_include} -I${directory_metil_include} -isysroot ${directory_sdk}

ifneq (${disable_metal_fast_options}, 1)
	metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=

all: ${name}

${name}: ${file_output}

ifeq (${target_os},macos)
${file_output}: ${files_objects_c} ${files_objects_objc} ${file_output_metal} ${files_storyboards_compiled} ${file_output_info_plist} ${files_textures_resources}
	if [[ ! -d ${directory_app_contents_macos} ]]; then mkdir -p ${directory_app_contents_macos}; fi
	${cc} ${c_flags_output} ${files_objects_c} ${files_objects_objc} ${files_libraries} -o ${file_output}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_output}
endif
ifneq (${release}, 1)
ifeq (${debug}, 1)
	if [[ ! -f ${directory_app_contents_macos}/cer0_debug.${version_target_cer0}.dylib ]]; then ln -s ${shell realpath ${file_cer0_library}} ${directory_app_contents_macos}/cer0_debug.${version_target_cer0}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/clic3_debug.${version_target_clic3}.dylib ]]; then ln -s ${shell realpath ${file_clic3_library}} ${directory_app_contents_macos}/clic3_debug.${version_target_clic3}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib ]]; then ln -s ${shell realpath ${file_interrupt_handler_library}} ${directory_app_contents_macos}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/math_c_debug.${version_target_math_c}.dylib ]]; then ln -s ${shell realpath ${file_math_c_library}} ${directory_app_contents_macos}/math_c_debug.${version_target_math_c}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/metil_debug.${version_target_metil}.dylib ]]; then ln -s ${shell realpath ${file_metil_library}} ${directory_app_contents_macos}/metil_debug.${version_target_metil}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/rand_debug.${version_target_rand}.dylib ]]; then ln -s ${shell realpath ${file_rand_library}} ${directory_app_contents_macos}/rand_debug.${version_target_rand}.dylib; fi
else
	if [[ ! -f ${directory_app_contents_macos}/cer0.${version_target_cer0}.dylib ]]; then ln -s ${shell realpath ${file_cer0_library}} ${directory_app_contents_macos}/cer0.${version_target_cer0}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/clic3.${version_target_clic3}.dylib ]]; then ln -s ${shell realpath ${file_clic3_library}} ${directory_app_contents_macos}/clic3.${version_target_clic3}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/interrupt_handler.${version_target_interrupt_handler}.dylib ]]; then ln -s ${shell realpath ${file_interrupt_handler_library}} ${directory_app_contents_macos}/interrupt_handler.${version_target_interrupt_handler}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/math_c.${version_target_math_c}.dylib ]]; then ln -s ${shell realpath ${file_math_c_library}} ${directory_app_contents_macos}/math_c.${version_target_math_c}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/metil.${version_target_metil}.dylib ]]; then ln -s ${shell realpath ${file_metil_library}} ${directory_app_contents_macos}/metil.${version_target_metil}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/rand.${version_target_rand}.dylib ]]; then ln -s ${shell realpath ${file_rand_library}} ${directory_app_contents_macos}/rand.${version_target_rand}.dylib; fi
endif
endif
endif

ifeq (${target_os},ios)
${file_output}: ${files_objects_c} ${files_objects_objc} ${file_output_metal} ${files_storyboards_compiled} ${file_output_info_plist} ${files_textures_resources}
	if [[ ! -d ${directory_output} ]]; then mkdir -p ${directory_output}; fi
	${cc} ${c_flags_platform} ${c_flags_frameworks} ${files_objects_c} ${files_objects_objc} ${files_libraries} -o ${file_output}
endif

${directory_output_textures}/%: ${directory_textures}/%
	if [[ ! -d ${directory_output_textures} ]]; then mkdir -p ${directory_output_textures}; fi
	cp ${<} ${@}

${file_output_metal}: ${file_metalar}
	if [[ ! -d ${directory_output_metal} ]]; then mkdir -p ${directory_output_metal}; fi
	${metallib} ${metal_flags_output} ${file_metalar} ${files_math_c_metalars} ${files_metil_metalars} -o ${file_output_metal}

${file_metalar}: ${files_air}
	if [[ ! -d ${directory_metalar} ]]; then mkdir -p ${directory_metalar}; fi
	if [[ -f ${file_metalar} ]]; then rm ${file_metalar}; fi
	${metal_ar} -rc ${file_metalar} ${files_air}

${directory_air}/%.air: ${directory_metal}/%.metal
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	${metal} ${metal_flags} -c ${<} -o ${@}

${directory_objects_c}/%.o: ${directory_sources}/%.c
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p "${dir ${@}}"; fi
	${cc} ${c_flags_c} -c ${<} -o ${@}

${directory_objects_objc}/%.o: ${directory_sources}/%.m
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p "${dir ${@}}"; fi
	${cc} ${c_flags_objc} -c ${<} -o ${@}

${directory_output_storyboards}/%.storyboardc: ${directory_storyboards}/%.storyboard
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${directory_output_storyboards}; fi
	ibtool --module ${name} --target-device ${target_device} --minimum-deployment-target ${target_device_version} --output-format human-readable-text $< --compilation-directory ${directory_output_storyboards}	

${directory_output_storyboards}/%.storyboardc: ${directory_metil_storyboards}/%.storyboard
	if [[ ! -d ${dir ${@} ]]; mkdir -p ${directory_output_storyboards}; fi
	ibtool --module ${name} --target-device ${target_device} --minimum-deployment-target ${target_device_version} --output-format human-readable-text $< --compilation-directory ${directory_output_storyboards}	

${file_output_info_plist}: ${file_info_plist}
	if [[ ! -d ${dir $@} ]]; then mkdir -p ${directory_output_info_plist}; fi
	cp ${file_info_plist} ${file_output_info_plist}

ifeq (${target_os},ios)
ifndef codesigning_id
codesigning_id=${shell security find-identity -v -p codesigning | grep "1)" | tr -s ' ' | cut -d ' ' -f 3}
endif

ifndef device_identifier
device_identifier=${shell devicectl list devices --filter "model beginswith 'iphone'" --filter "state == 'connected' || state beginswith 'available'" --hide-headers | head -n 1 | tr -s ' ' | grep -v "No devices found." | cut -d ' ' -f 3}
endif

bundle_identifier=dev.alic3.${name}
ifndef provisioning_profile_identifier
provisioning_profile_identifier=
endif
application_identifier=${provisioning_profile_identifier}.${bundle_identifier}

message_error_no_codesigning_id_found=no_codesigning_id_found
message_error_no_devices_found=no_devices_found

file_entitlements=${directory_output}/${name}.app.xcent

sign: .always
ifeq (${codesigning_id},)
	printf "${message_error_no_codesigning_id_found}\n" >&2
	exit 1
else
	printf "<plist>\n\n  <dict>\n    <key>application-identifier</key>\n    <string>${application_identifier}</string>\n  </dict>\n</plist>\n" > ${file_entitlements}
	codesign --force --sign ${codesigning_id} --entitlements ${file_entitlements} ${directory_output}
	rm ${file_entitlements}
endif

install: .always
ifeq (${device_identifier},)
	printf "${message_error_no_devices_found}\n" >&2
	exit 2
else
	devicectl device install app --device ${device_identifier} ${directory_output}
endif

run: .always
ifeq (${device_identifier},)
	printf "${message_error_no_devices_found}\n" >&2
	exit 2
else
	devicectl device process launch -d ${device_identifier} --console ${bundle_identifier}
endif
else
run:
	cd ${dir ${file_output}} && ./${shell basename ${file_output}}
endif

clean_all: clean

clean: clean_air clean_metalar clean_objects clean_output

clean_air:
	-rm -r ${directory_air_base} 2> /dev/null

clean_metalar:
	-rm -r ${directory_metalar_base} 2> /dev/null

clean_objects:
	-rm -r ${directory_objects_base} 2> /dev/null

clean_output:
	-rm -r ${directory_output_base} 2> /dev/null

.always:
