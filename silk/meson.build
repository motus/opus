silk_sources = [
  'CNG.c',
  'code_signs.c',
  'init_decoder.c',
  'decode_core.c',
  'decode_frame.c',
  'decode_parameters.c',
  'decode_indices.c',
  'decode_pulses.c',
  'decoder_set_fs.c',
  'dec_API.c',
  'enc_API.c',
  'encode_indices.c',
  'encode_pulses.c',
  'gain_quant.c',
  'interpolate.c',
  'LP_variable_cutoff.c',
  'NLSF_decode.c',
  'NSQ.c',
  'NSQ_del_dec.c',
  'PLC.c',
  'shell_coder.c',
  'tables_gain.c',
  'tables_LTP.c',
  'tables_NLSF_CB_NB_MB.c',
  'tables_NLSF_CB_WB.c',
  'tables_other.c',
  'tables_pitch_lag.c',
  'tables_pulses_per_block.c',
  'VAD.c',
  'control_audio_bandwidth.c',
  'quant_LTP_gains.c',
  'VQ_WMat_EC.c',
  'HP_variable_cutoff.c',
  'NLSF_encode.c',
  'NLSF_VQ.c',
  'NLSF_unpack.c',
  'NLSF_del_dec_quant.c',
  'process_NLSFs.c',
  'stereo_LR_to_MS.c',
  'stereo_MS_to_LR.c',
  'check_control_input.c',
  'control_SNR.c',
  'init_encoder.c',
  'control_codec.c',
  'A2NLSF.c',
  'ana_filt_bank_1.c',
  'biquad_alt.c',
  'bwexpander_32.c',
  'bwexpander.c',
  'debug.c',
  'decode_pitch.c',
  'inner_prod_aligned.c',
  'lin2log.c',
  'log2lin.c',
  'LPC_analysis_filter.c',
  'LPC_inv_pred_gain.c',
  'table_LSF_cos.c',
  'NLSF2A.c',
  'NLSF_stabilize.c',
  'NLSF_VQ_weights_laroia.c',
  'pitch_est_tables.c',
  'resampler.c',
  'resampler_down2_3.c',
  'resampler_down2.c',
  'resampler_private_AR2.c',
  'resampler_private_down_FIR.c',
  'resampler_private_IIR_FIR.c',
  'resampler_private_up2_HQ.c',
  'resampler_rom.c',
  'sigm_Q15.c',
  'sort.c',
  'sum_sqr_shift.c',
  'stereo_decode_pred.c',
  'stereo_encode_pred.c',
  'stereo_find_predictor.c',
  'stereo_quant_pred.c',
  'LPC_fit.c',
]

silk_sources_sse4_1 = [
  'x86/NSQ_sse4_1.c',
  'x86/NSQ_del_dec_sse4_1.c',
  'x86/x86_silk_map.c',
  'x86/VAD_sse4_1.c',
  'x86/VQ_WMat_EC_sse4_1.c',
]

silk_sources_neon_intr = [
  'arm/arm_silk_map.c',
  'arm/biquad_alt_neon_intr.c',
  'arm/LPC_inv_pred_gain_neon_intr.c',
  'arm/NSQ_del_dec_neon_intr.c',
  'arm/NSQ_neon.c',
]

silk_sources_fixed_neon_intr = [
  'fixed/arm/warped_autocorrelation_FIX_neon_intr.c',
]

silk_sources_fixed = [
  'fixed/LTP_analysis_filter_FIX.c',
  'fixed/LTP_scale_ctrl_FIX.c',
  'fixed/corrMatrix_FIX.c',
  'fixed/encode_frame_FIX.c',
  'fixed/find_LPC_FIX.c',
  'fixed/find_LTP_FIX.c',
  'fixed/find_pitch_lags_FIX.c',
  'fixed/find_pred_coefs_FIX.c',
  'fixed/noise_shape_analysis_FIX.c',
  'fixed/process_gains_FIX.c',
  'fixed/regularize_correlations_FIX.c',
  'fixed/residual_energy16_FIX.c',
  'fixed/residual_energy_FIX.c',
  'fixed/warped_autocorrelation_FIX.c',
  'fixed/apply_sine_window_FIX.c',
  'fixed/autocorr_FIX.c',
  'fixed/burg_modified_FIX.c',
  'fixed/k2a_FIX.c',
  'fixed/k2a_Q16_FIX.c',
  'fixed/pitch_analysis_core_FIX.c',
  'fixed/vector_ops_FIX.c',
  'fixed/schur64_FIX.c',
  'fixed/schur_FIX.c',
]

silk_sources_fixed_sse4_1 = [
  'fixed/x86/vector_ops_FIX_sse4_1.c',
  'fixed/x86/burg_modified_FIX_sse4_1.c',
]

silk_sources_float = [
  'float/apply_sine_window_FLP.c',
  'float/corrMatrix_FLP.c',
  'float/encode_frame_FLP.c',
  'float/find_LPC_FLP.c',
  'float/find_LTP_FLP.c',
  'float/find_pitch_lags_FLP.c',
  'float/find_pred_coefs_FLP.c',
  'float/LPC_analysis_filter_FLP.c',
  'float/LTP_analysis_filter_FLP.c',
  'float/LTP_scale_ctrl_FLP.c',
  'float/noise_shape_analysis_FLP.c',
  'float/process_gains_FLP.c',
  'float/regularize_correlations_FLP.c',
  'float/residual_energy_FLP.c',
  'float/warped_autocorrelation_FLP.c',
  'float/wrappers_FLP.c',
  'float/autocorrelation_FLP.c',
  'float/burg_modified_FLP.c',
  'float/bwexpander_FLP.c',
  'float/energy_FLP.c',
  'float/inner_product_FLP.c',
  'float/k2a_FLP.c',
  'float/LPC_inv_pred_gain_FLP.c',
  'float/pitch_analysis_core_FLP.c',
  'float/scale_copy_vector_FLP.c',
  'float/scale_vector_FLP.c',
  'float/schur_FLP.c',
  'float/sort_FLP.c',
]

if opt_fixed_point
  silk_sources += silk_sources_fixed
else
  silk_sources += silk_sources_float
endif

silk_includes = [opus_includes, include_directories('float', 'fixed')]
silk_static_libs = []

foreach intr_name : ['sse4_1', 'neon_intr']
  have_intr = get_variable('have_' + intr_name)
  if not have_intr
    continue
  endif

  intr_sources = get_variable('silk_sources_' + intr_name)
  if opt_fixed_point
    intr_sources += get_variable('silk_sources_fixed_' + intr_name)
  endif

  intr_args = get_variable('opus_@0@_args'.format(intr_name), [])
  silk_static_libs += static_library('silk_' + intr_name, intr_sources,
      c_args: intr_args,
      include_directories: silk_includes,
      install: false)
endforeach

silk_c_args = []
if host_machine.system() == 'windows'
  silk_c_args += ['-DDLL_EXPORT']
endif

silk_lib = static_library('opus-silk',
  silk_sources,
  c_args: silk_c_args,
  include_directories: silk_includes,
  link_whole: silk_static_libs,
  dependencies: libm,
  install: false)
