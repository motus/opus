# Tests that link to libopus
opus_tests = [
  ['test_opus_api'],
  ['test_opus_decode'],
  ['test_opus_encode', 'opus_encode_regressions.c', 120],
  ['test_opus_padding'],
  ['test_opus_projection'],
]

foreach t : opus_tests
  test_name = t.get(0)
  extra_srcs = t.get(1, [])
  timeout = t.get(2, 30)
  exe = executable(test_name, '@0@.c'.format(test_name), extra_srcs,
    include_directories: opus_includes,
    c_args: opus_c_args,
    link_with: opus_lib,
    dependencies: libm,
    install: false)
  test(test_name, exe, timeout: timeout)
endforeach
