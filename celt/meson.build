celt_sources = [
  'bands.c',
  'celt.c',
  'celt_encoder.c',
  'celt_decoder.c',
  'cwrs.c',
  'entcode.c',
  'entdec.c',
  'entenc.c',
  'kiss_fft.c',
  'laplace.c',
  'mathops.c',
  'mdct.c',
  'modes.c',
  'pitch.c',
  'celt_lpc.c',
  'quant_bands.c',
  'rate.c',
  'vq.c',
]

if may_have_sse
  celt_sources += [
    'x86/x86cpu.c',
    'x86/x86_celt_map.c',
    'x86/pitch_sse.c',
  ]
endif

if may_have_sse2
  celt_sources += [
    'x86/pitch_sse2.c',
    'x86/vq_sse2.c',
  ]
endif

if may_have_sse4_1
  celt_sources += [
    'x86/celt_lpc_sse4_1.c',
    'x86/pitch_sse4_1.c',
  ]
endif

opus_armasm_lib = []

if host_machine.cpu_family() == 'arm' # was: cpu_arm # FIXME: should only be used if intrinsics or asm is enabled
  celt_sources +=  [
    'arm/armcpu.c',
    'arm/arm_celt_map.c',
  ]
  if may_have_neon
    celt_sources += [
      'arm/celt_neon_intr.c',
    ]
  endif
  if have_arm_ne10
    celt_sources += [
    'arm/celt_ne10_fft.c',
    'arm/celt_ne10_mdct.c',
  ]
  endif
  if opus_arm_external_asm
    # FIXME: arm2gnu.pl stuff?
    celt_sources_arm_asm = [
      'arm/celt_pitch_xcorr_arm.s',
    ]
    celt_arm_armopts_s = configure_file(input: 'arm/armopts.s.in',
      output: 'arm/armopts.s',
      configuration: opus_conf)
    opus_armasm_lib = static_library('opus-armasm',
      celt_arm_armopts_s, celt_sources_arm_asm,
      install: false)
  endif
endif

celt_c_args = []
if host_machine.system() == 'windows'
  celt_c_args += ['-DDLL_EXPORT']
endif

celt_lib = static_library('opus-celt',
  celt_sources,
  c_args: opus_c_args + celt_c_args,
  include_directories: opus_includes,
  link_with: opus_armasm_lib,
  dependencies: libm,
  install: false)
