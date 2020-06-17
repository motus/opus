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

celt_sse_sources = [
  'x86/x86cpu.c',
  'x86/x86_celt_map.c',
  'x86/pitch_sse.c',
]

celt_sse2_sources = [
  'x86/pitch_sse2.c',
  'x86/vq_sse2.c',
]

celt_sse4_1_sources = [
  'x86/celt_lpc_sse4_1.c',
  'x86/pitch_sse4_1.c',
]

celt_neon_intr_sources = [
  'arm/celt_neon_intr.c',
  'arm/pitch_neon_intr.c',
]

celt_static_libs = []

foreach intr_name : ['sse', 'sse2', 'sse4_1', 'neon_intr']
  have_intr = get_variable('have_' + intr_name)
  if not have_intr
    continue
  endif

  intr_sources = get_variable('celt_@0@_sources'.format(intr_name))
  intr_args = get_variable('opus_@0@_args'.format(intr_name), [])
  celt_static_libs += static_library('celt_' + intr_name, intr_sources,
      c_args: intr_args,
      include_directories: opus_includes,
      install: false)
endforeach

have_arm_intrinsics_or_asm = have_arm_ne10
if (intrinsics_support.length() + asm_optimization.length() + inline_optimization.length()) > 0
  have_arm_intrinsics_or_asm = true
endif

if host_cpu_family in ['arm', 'aarch64'] and have_arm_intrinsics_or_asm
  celt_sources +=  [
    'arm/armcpu.c',
    'arm/arm_celt_map.c',
  ]
  if have_arm_ne10
    celt_sources += [
    'arm/celt_fft_ne10.c',
    'arm/celt_mdct_ne10.c',
  ]
  endif
  if opus_arm_external_asm
    arm2gnu = [find_program('arm/arm2gnu.pl')] + arm2gnu_args
    celt_sources_arm_asm = configure_file(input: 'arm/celt_pitch_xcorr_arm.s',
      output: '@BASENAME@-gnu.S',
      command: arm2gnu + ['@INPUT@'],
      capture: true)
    celt_arm_armopts_s = configure_file(input: 'arm/armopts.s.in',
      output: 'arm/armopts.s',
      configuration: opus_conf)
    celt_static_libs += static_library('celt-armasm',
      celt_arm_armopts_s, celt_sources_arm_asm,
      install: false)
  endif
endif

celt_c_args = []
if host_system == 'windows'
  celt_c_args += ['-DDLL_EXPORT']
endif

celt_lib = static_library('opus-celt',
  celt_sources,
  c_args: celt_c_args,
  include_directories: opus_includes,
  link_whole: celt_static_libs,
  dependencies: libm,
  install: false)
