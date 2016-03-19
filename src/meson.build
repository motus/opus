opus_sources = [
  'opus.c',
  'opus_decoder.c',
  'opus_encoder.c',
  'opus_multistream.c',
  'opus_multistream_encoder.c',
  'opus_multistream_decoder.c',
  'repacketizer.c',
]

opus_sources_float = [
  'analysis.c',
  'mlp.c',
  'mlp_data.c',
]

if not disable_float_api
  opus_sources += opus_sources_float
endif

opus_lib_c_args = []
if host_machine.system() == 'windows'
  opus_lib_c_args += ['-DDLL_EXPORT']
endif

opus_lib = library('opus',
  opus_sources,
# FIXME  version : libversion,
# FIXME soversion : soversion,
  c_args: opus_c_args + opus_lib_c_args,
  include_directories: opus_includes,
  link_with: [celt_lib, silk_lib],
  dependencies: libm,
  install: true)

opus_dep = declare_dependency(link_with: opus_lib,
  include_directories: opus_public_includes)

# Extra uninstalled Opus programs
if not disable_extra_programs
  extra_programs = ['opus_compare', 'opus_demo', 'repacketizer_demo']

  foreach prog : extra_programs
    executable(prog, '@0@.c'.format(prog),
               include_directories: opus_includes,
               c_args: opus_c_args,
               link_with: opus_lib,
               dependencies: libm,
               install: false)
  endforeach

  if opt_custom_modes
    executable('opus_custom_demo', '../celt/opus_custom_demo.c',
               include_directories: opus_includes,
               c_args: opus_c_args,
               link_with: opus_lib,
               dependencies: libm,
               install: false)
  endif

endif # not disable_extra_programs
