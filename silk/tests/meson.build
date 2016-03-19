exe = executable('test_unit_LPC_inv_pred_gain',
  'test_unit_LPC_inv_pred_gain.c', '../LPC_inv_pred_gain.c',
  include_directories: opus_includes,
  c_args: opus_c_args,
  link_with: [opus_armasm_lib, celt_lib, silk_lib],
  dependencies: libm,
  install: false)

test(test_name, exe)

