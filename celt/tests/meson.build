tests = [
  'test_unit_types',
  'test_unit_mathops',
  'test_unit_entropy',
  'test_unit_laplace',
  'test_unit_dft',
  'test_unit_mdct',
  'test_unit_rotation',
  'test_unit_cwrs32',
]

test_args = []
if cc.get_id() == 'msvc'
  test_args += ['/wd4305'] # trunction from double to float in mathops
endif

foreach test_name : tests
  exe = executable(test_name, '@0@.c'.format(test_name),
                   include_directories : opus_includes,
                   c_args : opus_c_args + test_args,
                   link_with : [opus_armasm_lib, celt_lib],
                   dependencies : libm,
                   install : false)
  test(test_name, exe)
endforeach
