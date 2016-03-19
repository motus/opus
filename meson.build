# Based on git v1.2.1-35-geee68982
project('opus', 'c',
  version: '1.2.1',
  meson_version: '>= 0.47.0',
  default_options: ['warning_level=1',
                    'c_std=gnu99',
                    'buildtype=debugoptimized'])

cc = meson.get_compiler('c')

opus_includes = include_directories('.', 'include', 'celt', 'silk')
opus_public_includes = include_directories('include')

add_project_arguments('-DOPUS_BUILD', language: 'c')
add_project_arguments('-DHAVE_CONFIG_H', language: 'c')

if host_machine.system() == 'windows'
  add_project_arguments('-DWIN32', language: 'c')
  if cc.get_id() == 'msvc'
    add_project_arguments('-D_CRT_SECURE_NO_WARNINGS', language: 'c')
  endif
endif

# Check for extra compiler args
additional_c_args = []
if cc.get_id() != 'msvc'
  additional_c_args += [
    '-fvisibility=hidden',
    '-Wall',
    '-Wextra',
    '-Wcast-align',
    '-Wnested-externs',
    '-Wshadow',
    '-Wstrict-prototypes',
  ]
endif

foreach arg : additional_c_args
  if cc.has_argument(arg)
    add_project_arguments(arg, language: 'c')
  endif
endforeach

# Windows MSVC warnings
if cc.get_id() == 'msvc'
  # Ignore several spurious warnings.
  # If a warning is completely useless and spammy, use '/wdXXXX' to suppress it
  # If a warning is harmless but hard to fix, use '/woXXXX' so it's shown once
  # NOTE: Only add warnings here if you are sure they're spurious
  add_project_arguments('/wd4035', '/wd4715', '/wd4116', '/wd4046', '/wd4068',
    '/wd4820', '/wd4244', '/wd4255', '/wd4668',
    #'/FImsvc_recommended_pragmas.h',
    language : 'c')
endif

opus_c_args = []

# FIXME: CURRENT_VERSION from git script, so e.g. 1.1.1-rc-71-gc43b1bc
opus_version = meson.project_version()

opus_conf = configuration_data()
opus_conf.set('PACKAGE_BUGREPORT', '"opus@xiph.org"')
opus_conf.set('PACKAGE_NAME', '"opus"')
opus_conf.set('PACKAGE_STRING', '"opus @0@"'.format(opus_version))
opus_conf.set('PACKAGE_TARNAME', '"opus"')
opus_conf.set('PACKAGE_URL', '""')
opus_conf.set('PACKAGE_VERSION', '"@0@"'.format(opus_version))

# FIXME: optional Ne10 dependency
have_arm_ne10 = false

libm = cc.find_library('m', required : false)

opus_conf.set('HAVE_LRINTF', cc.has_function('lrintf', prefix: '#include <math.h>', dependencies: libm))
opus_conf.set('HAVE_LRINT', cc.has_function('lrint', prefix: '#include <math.h>', dependencies: libm))
opus_conf.set('HAVE___MALLOC_HOOK', cc.has_function('__malloc_hook', prefix: '#include <malloc.h>'))

# Check for restrict keyword
restrict_tmpl = '''
typedef int * int_ptr;
int foo (int_ptr @0@ ip, int * @0@ baz[]) {
  return ip[0];
}
int main (int argc, char ** argv) {
  int s[1];
  int * @0@ t = s;
  t[0] = 0;
  return foo(t, (void *)0);
}'''
# Define restrict to the equivalent of the C99 restrict keyword, or to
# nothing if this is not supported.  Do not define if restrict is
# supported directly.
if not cc.compiles(restrict_tmpl.format('restrict'), name : 'restrict keyword')
  if cc.compiles(restrict_tmpl.format('__restrict'), name : '__restrict')
    opus_conf.set('restrict', '__restrict')
  elif cc.compiles(restrict_tmpl.format('__restrict__'), name : '__restrict__')
    opus_conf.set('restrict', '__restrict')
  elif cc.compiles(restrict_tmpl.format('_Restrict'), name : '_Restrict')
    opus_conf.set('restrict', '_Restrict')
  else
    opus_conf.set('restrict', '/**/')
  endif
endif

# Check for C99 variable-size arrays, or alloca() as fallback
msg_c99_var_arrays = 'no'
msg_use_alloca = 'no'
if false and cc.compiles('''static int x;
                  char some_func (void) {
                    char a[++x];
                    a[sizeof a - 1] = 0;
                    int N;
                    return a[0];
                  }''', name : 'C99 variable-size arrays')
  opus_conf.set('VAR_ARRAYS', 1)
  msg_c99_var_arrays = 'yes'
  msg_use_alloca = 'no (using C99 variable-size arrays instead)'
elif cc.compiles('''#include <alloca.h>
                    void some_func (void) {
                      int foo=10;
                      int * array = alloca(foo);
                    }''', name : 'alloca (alloca.h)')
  opus_conf.set('USE_ALLOCA', true)
  opus_conf.set('HAVE_ALLOCA_H', true)
  msg_use_alloca = 'yes'
elif cc.compiles('''#include <malloc.h>
                    #include <stdlib.h>
                    void some_func (void) {
                      int foo=10;
                      int * array = alloca(foo);
                    }''', name : 'alloca (std)')
  opus_conf.set('USE_ALLOCA', true)
  msg_use_alloca = 'yes'
endif

opts = [
  [ 'fixed-point', 'FIXED_POINT' ],
  [ 'fixed-point-debug', 'FIXED_DEBUG' ],
  [ 'custom-modes', 'CUSTOM_MODES' ],
  [ 'float-approx', 'FLOAT_APPROX' ],
  [ 'assertions', 'ENABLE_ASSERTIONS' ],
  [ 'fuzzing', 'FUZZING' ],
]

foreach opt : opts
  # we assume these are all boolean options
  opt_foo = get_option(opt[0])
  if opt_foo
    opus_conf.set(opt[1], 1)
  endif
  set_variable('opt_' + opt[0].underscorify(), opt_foo)
endforeach

enable_asm = not get_option('disable-asm')
enable_rtcd = not get_option('disable-rtcd')
enable_intrinsics = get_option('enable-intrinsics')
disable_extra_programs = get_option('disable-extra-programs')
disable_tests = get_option('disable-tests')

disable_float_api = not get_option('float-api')
if disable_float_api
  opus_conf.set('DISABLE_FLOAT_API', 1)
endif

# This is for the description in the pkg-config .pc file
if opt_fixed_point
  pc_build = 'fixed-point'
else
  pc_build = 'floating-point'
endif
if opt_custom_modes
  pc_build = pc_build + ', custom modes'
endif

rtcd_support = 'no'
cpu_arm = false # FIXME: check, unused
opus_arm_external_asm = false

asm_tmpl = '''
int main (int argc, char ** argv) {
  __asm__("@0@");
  return 0;
}'''

asm_optimization='none'
if enable_asm
  inline_optimization='No inline ASM for your platform, please send patches'
  # Currently we only have asm for fixed-point
  if host_machine.cpu_family() == 'arm' and opt_fixed_point
    cpu_arm = true
    opus_conf.set('OPUS_ARM_ASM', true)

    # Check if compiler supports gcc-style inline assembly
    if cc.compiles('''#ifdef __GNUC_MINOR__
                      #if (__GNUC__ * 1000 + __GNUC_MINOR__) < 3004
                      #error GCC before 3.4 has critical bugs compiling inline assembly
                      #endif
                      #endif
                      __asm__ (""::)''',
                   name :  'Compiler supports gcc-style inline assembly')
      inline_optimization = 'ARM'

      opus_conf.set('OPUS_ARM_INLINE_ASM', 1)

      # AS_ASM_ARM_EDSP
      if cc.compiles(asm_tmpl.format('qadd r3,r3,r3'),
                     name : 'Assembler supports EDSP instructions on ARM')
        opus_conf.set('OPUS_ARM_INLINE_EDSP', 1)
        inline_optimization = inline_optimization + ' (ESDP)'
      endif

      # AS_ASM_ARM_MEDIA
      if cc.compiles(asm_tmpl.format('shadd8 r3,r3,r3'),
                     name : 'Assembler supports ARMv6 media instructions on ARM')
        opus_conf.set('OPUS_ARM_INLINE_MEDIA', 1)
        inline_optimization = inline_optimization + ' (Media)'
      endif

      # AS_ASM_ARM_NEON
      if cc.compiles(asm_tmpl.format('vorr d0,d0,d0'),
                     name : 'Assembler supports NEON instructions on ARM')
        opus_conf.set('OPUS_ARM_INLINE_NEON', 1)
        inline_optimization = inline_optimization + ' (NEON)'
      endif
    else
      inline_optimization = 'disabled'
    endif

    # We need Perl to translate RVCT-syntax asm to gas syntax
    # FIXME: for now we just error out if no perl is found
    perl = find_program('perl', required : true)
    if perl.found()
      opus_arm_external_asm = true
      asm_optimization = 'ARM'

      opus_arm_presume_edsp = opus_conf.has('OPUS_ARM_INLINE_EDSP')
      opus_arm_may_have_edsp = opus_arm_presume_edsp

      opus_arm_presume_media = opus_conf.has('OPUS_ARM_INLINE_MEDIA')
      opus_arm_may_have_media = opus_arm_presume_media

      opus_arm_presume_neon = opus_conf.has('OPUS_ARM_INLINE_NEON')
      opus_arm_may_have_neon = opus_arm_presume_neon

      if enable_rtcd
        if not opus_arm_may_have_edsp
          message('Trying to force-enable armv5e EDSP instructions...')
          # AS_ASM_ARM_EDSP_FORCE
          opus_arm_may_have_edsp = cc.compiles(asm_tmpl.format('.arch armv5te\n.object_arch armv4t\nqadd r3,r3,r3'),
                                               name : 'Assembler supports EDSP instructions on ARM (forced)')
        endif
        if not opus_arm_may_have_media
          message('Trying to force-enable ARMv6 media instructions...')
          opus_arm_may_have_media = cc.compiles(asm_tmpl.format('.arch armv6\n.object_arch armv4t\nshadd8 r3,r3,r3'),
                                                name : 'Assembler supports ARMv6 media instructions on ARM (forced)')
        endif
        if not opus_arm_may_have_neon
          message('Trying to force-enable NEON instructions...')
          opus_arm_may_have_neon = cc.compiles(asm_tmpl.format('.arch armv7-a\n.fpu neon\n.object_arch armv4t\nvorr d0,d0,d0'),
                                               name : 'Assembler supports NEON instructions on ARM (forced)')
        endif
      endif

      rtcd_support = ''
      if opus_arm_may_have_edsp
        opus_conf.set('OPUS_ARM_MAY_HAVE_EDSP', 1)
        if opus_arm_presume_edsp
          opus_conf.set('OPUS_ARM_PRESUME_EDSP', 1)
          asm_optimization = asm_optimization + ' (EDSP)'
        else
          rtcd_support = rtcd_support + ' (EDSP)'
        endif
      endif
      if opus_arm_may_have_media
        opus_conf.set('OPUS_ARM_MAY_HAVE_MEDIA', 1)
        if opus_arm_presume_media
          opus_conf.set('OPUS_ARM_PRESUME_MEDIA', 1)
          asm_optimization = asm_optimization + ' (Media)'
        else
          rtcd_support = rtcd_support + ' (Media)'
        endif
      endif
      if opus_arm_may_have_neon
        opus_conf.set('OPUS_ARM_MAY_HAVE_NEON', 1)
        if opus_arm_presume_neon
          opus_conf.set('OPUS_ARM_PRESUME_NEON', 1)
          asm_optimization = asm_optimization + ' (NEON)'
        else
          rtcd_support = rtcd_support + ' (NEON)'
        endif
      endif

      # Make sure turning on RTCD gets us at least one instruction set
      if rtcd_support != ''
        rtcd_support = 'ARM ' + rtcd_support
      else
        rtcd_support = 'no'
      endif

      # Check for apple-style tools
      if cc.compiles('''#ifndef __APPLE__
                        #error not apple
                        #endif''', name : 'Apple-style tools')
        arm2gnu_params = '--apple' # FIXME: use somewhere
      else
        arm2gnu_params = ''
      endif
    endif # found perl
  endif # arm + enable fixed point
else # enable asm
  inline_optimization='disabled'
  asm_optimization='disabled'
endif

intrinsics_foo='''
m4_define([DEFAULT_ARM_NEON_INTR_CFLAGS], [-mfpu=neon])
# With GCC on ARM32 softfp architectures (e.g. Android, or older Ubuntu) you need to specify
# -mfloat-abi=softfp for -mfpu=neon to work.  However, on ARM32 hardfp architectures (e.g. newer Ubuntu),
# this option will break things.

# As a heuristic, if host matches arm*eabi* but not arm*hf*, it's probably soft-float.
m4_define([DEFAULT_ARM_NEON_SOFTFP_INTR_CFLAGS], [-mfpu=neon -mfloat-abi=softfp])

AS_CASE([$host],
	[arm*hf*], [AS_VAR_SET([RESOLVED_DEFAULT_ARM_NEON_INTR_CFLAGS], "DEFAULT_ARM_NEON_INTR_CFLAGS")],
	[arm*eabi*], [AS_VAR_SET([RESOLVED_DEFAULT_ARM_NEON_INTR_CFLAGS], "DEFAULT_ARM_NEON_SOFTFP_INTR_CFLAGS")],
	[AS_VAR_SET([RESOLVED_DEFAULT_ARM_NEON_INTR_CFLAGS], "DEFAULT_ARM_NEON_INTR_CFLAGS")])

AC_ARG_VAR([ARM_NEON_INTR_CFLAGS], [C compiler flags to compile ARM NEON intrinsics @<:@default=]DEFAULT_ARM_NEON_INTR_CFLAGS / DEFAULT_ARM_NEON_SOFTFP_INTR_CFLAGS[@:>@])

AS_VAR_SET_IF([ARM_NEON_INTR_CFLAGS], [], [AS_VAR_SET([ARM_NEON_INTR_CFLAGS], ["$RESOLVED_DEFAULT_ARM_NEON_INTR_CFLAGS"])])
'''

may_have_sse = false
may_have_sse2 = false
may_have_sse4_1 = false
may_have_avx = false

may_have_neon = false  # FIXME: merge with / fixup opus_arm_may_have_neon

if enable_intrinsics
  intrinsics_support = ''
  rtcd_support = ''
  if host_machine.cpu_family().startswith('arm')
foo1_arm='''
   AS_CASE([$host_cpu],
   [arm*],
   [
      cpu_arm=yes
      OPUS_CHECK_INTRINSICS(
         [ARM Neon],
         [$ARM_NEON_INTR_CFLAGS],
         [OPUS_ARM_MAY_HAVE_NEON_INTR],
         [OPUS_ARM_PRESUME_NEON_INTR],
         [[#include <arm_neon.h>
         ]],
         [[
            static float32x4_t A0, A1, SUMM;
            SUMM = vmlaq_f32(SUMM, A0, A1);
         ]]
      )
      AS_IF([test x"$OPUS_ARM_MAY_HAVE_NEON_INTR" = x"1" && test x"$OPUS_ARM_PRESUME_NEON_INTR" != x"1"],
          [
             OPUS_ARM_NEON_INTR_CFLAGS="$ARM_NEON_INTR_CFLAGS"
             AC_SUBST([OPUS_ARM_NEON_INTR_CFLAGS])
          ]
      )

      AS_IF([test x"$OPUS_ARM_MAY_HAVE_NEON_INTR" = x"1"],
      [
         AC_DEFINE([OPUS_ARM_MAY_HAVE_NEON_INTR], 1, [Compiler supports ARMv7 Neon Intrinsics])
         intrinsics_support="$intrinsics_support (Neon_Intrinsics)"

         AS_IF([test x"enable_rtcd" != x"" && test x"$OPUS_ARM_PRESUME_NEON_INTR" != x"1"],
            [rtcd_support="$rtcd_support (ARMv7_Neon_Intrinsics)"])

         AS_IF([test x"$OPUS_ARM_PRESUME_NEON_INTR" = x"1"],
            [AC_DEFINE([OPUS_ARM_PRESUME_NEON_INTR], 1, [Define if binary requires NEON intrinsics support])])

         OPUS_PATH_NE10()
         AS_IF([test x"$NE10_LIBS" != x""],
         [
              intrinsics_support="$intrinsics_support (NE10)"
              AS_IF([test x"enable_rtcd" != x"" \
               && test x"$OPUS_ARM_PRESUME_NEON_INTR" != x"1"],
                 [rtcd_support="$rtcd_support (NE10)"])
         ])

         AS_IF([test x"$rtcd_support" = x""],
            [rtcd_support=no])

         AS_IF([test x"$intrinsics_support" = x""],
            [intrinsics_support=no],
            [intrinsics_support="arm$intrinsics_support"])
      ],
      [
         AC_MSG_WARN([Compiler does not support ARM intrinsics])
         intrinsics_support=no
      ])
   ],
'''
  elif host_machine.cpu_family().startswith('x86')
    # FIXME: allow external override/specification of the flags
    x86_intrinsics = [
      [ 'SSE', 'xmmintrin.h', '__m128', '_mm_setzero_ps()', '-msse' ],
      [ 'SSE2', 'emmintrin.h', '__m128i', '_mm_setzero_si128()', '-msse2' ],
      [ 'SSE4.1', 'smmintrin.h', '__m128i', '_mm_setzero_si128(); mtest = _mm_cmpeq_epi64(mtest, mtest)', '-msse4.1' ],
      [ 'AVX', 'immintrin.h', '__m256', '_mm256_setzero_ps()', '-mavx' ],
    ]

    foreach intrin : x86_intrinsics
      intrin_check = '''#include <@0@>
                        int main (int argc, char ** argv) {
                          static @1@ mtest;
                          mtest = @2@;
                          return *((unsigned char *) &mtest) != 0;
                        }'''.format(intrin.get(1),intrin.get(2),intrin.get(3))
      intrin_name = intrin.get(0)
      intrin_link_args = intrin.get(4)
      if cc.links(intrin_check, name : 'if compiler supports @0@ intrinsics'.format(intrin_name))
        may_have_intrin = true
        presume_intrin = true
      else
        presume_intrin = false
        if cc.links(intrin_check,
                    args : intrin_link_args,
                    name : 'if compiler supports @0@ intrinsics with @1@'.format(intrin_name,intrin_link_args))
          may_have_intrin = true
          # FIXME: add args to some var and use it later
        else
          may_have_intrin = false
        endif
      endif
      set_variable('may_have_' + intrin_name.to_lower().underscorify(), may_have_intrin)
      # FIXME: unused: set_variable('presume_' + intrin_name.to_lower().underscorify(), presume_intrin)
      if may_have_intrin
        intrinsics_support = intrinsics_support + ' ' + intrin_name
        opus_conf.set('OPUS_X86_MAY_HAVE_' + intrin_name.underscorify(), 1)
        if presume_intrin
          opus_conf.set('OPUS_X86_PRESUME_' + intrin_name.underscorify(), 1)
        else
          rtcd_support = rtcd_support + ' ' + intrin_name
          opus_c_args += [ intrin_link_args ]
        endif
      else
        message('Warning: Compiler does not support @0@ intrinsics'.format(intrin_name))
      endif
    endforeach

    if intrinsics_support == ''
      intrinsics_support = 'no'
    else
      intrinsics_support = 'x86' + intrinsics_support
    endif

    if rtcd_support == ''
      rtcd_support = 'no'
    else
      rtcd_support = 'x86' + rtcd_support
    endif

    if enable_rtcd and rtcd_support != 'no'
      get_cpuid_by_asm = false
      cpuid_asm_code = '''
        #include <stdio.h>
        int main (int argc, char ** argv) {
          unsigned int CPUInfo0;
          unsigned int CPUInfo1;
          unsigned int CPUInfo2;
          unsigned int CPUInfo3;
          unsigned int InfoType;
          __asm__ __volatile__ (
            "cpuid":
            "=a" (CPUInfo0),
            "=b" (CPUInfo1),
            "=c" (CPUInfo2),
            "=d" (CPUInfo3) :
            "a" (InfoType), "c" (0)
          );
          return 0;
        }'''
      cpuid_c_code = '''
        #include <cpuid.h>
        int main (int argc, char ** argv) {
          unsigned int CPUInfo0;
          unsigned int CPUInfo1;
          unsigned int CPUInfo2;
          unsigned int CPUInfo3;
          unsigned int InfoType;
          __get_cpuid(InfoType, &CPUInfo0, &CPUInfo1, &CPUInfo2, &CPUInfo3);
          return 0;
        }'''
      if cc.links(cpuid_asm_code, name : 'Get X86 CPU info via inline assembly')
        opus_conf.set('CPU_INFO_BY_ASM', 1)
      elif cc.links(cpuid_c_code, name : 'Get X86 CPU info via C method')
        opus_conf.set('CPU_INFO_BY_C', 1)
      else
        error('No supported Get CPU Info method, please disable intrinsics')
      endif
    endif
  else
    message('Warning: No intrinsics support for your architecture (@0@)'.format(host_machine.get_cpu()))
    intrinsics_support = 'no'
  endif
else
  intrinsics_support = 'no'
endif

if enable_rtcd
  if rtcd_support != 'no'
    opus_conf.set('OPUS_HAVE_RTCD', 1)
  endif
else
  rtcd_support = 'disabled'
endif

subdir('include')
subdir('silk')
subdir('celt')
subdir('src')

configure_file(output: 'config.h', configuration: opus_conf)

if not disable_tests
  subdir('celt/tests')
  subdir('silk/tests')
  subdir('tests')
endif

# pkg-config files
# FIXME: use pkg-config import module instead?
pkgconf = configuration_data()

pkgconf.set('prefix', join_paths(get_option('prefix')))
pkgconf.set('exec_prefix', '${prefix}')
pkgconf.set('libdir', '${prefix}/@0@'.format(get_option('libdir')))
pkgconf.set('includedir', '${prefix}/@0@'.format(get_option('includedir')))
pkgconf.set('VERSION', opus_version)
pkgconf.set('PC_BUILD', pc_build)
if libm.found()
  pkgconf.set('LIBM', '-lm')
endif

pkg_install_dir = '@0@/pkgconfig'.format(get_option('libdir'))

configure_file(input : 'opus.pc.in',
  output : 'opus.pc',
  configuration : pkgconf,
  install_dir : pkg_install_dir)

# The uninstalled one has hardcoded libtool + static lib stuff, skip it for now
#configure_file(input : 'opus-uninstalled.pc.in',
#  output : 'opus-uninstalled.pc',
#  configuration : pkgconf,
#  install : false)

doxygen = find_program('doxygen', required: get_option('docs'))
have_doxygen = doxygen.found()
if have_doxygen
  msg_doc = 'yes'
  subdir('doc')
else
  if get_option('docs').disabled()
    msg_doc = 'disabled'
  else
    msg_doc = 'not found'
  endif
endif

# FIXME: use bool.to_string('yes', 'no') here once meson 0.31 is out
# FIXME: only print the ninja help if ninja is used as backend
msg_c99_lrintf = opus_conf.has('HAVE_LRINTF').to_string()
message('''
------------------------------------------------------------------------
  opus @0@:  Automatic configuration OK.

    Compiler support:

      C99 var arrays: ................ @1@
      C99 lrintf: .................... @2@
      Use alloca: .................... @3@

    General configuration:

      Floating point support: ........ @4@
      Fast float approximations: ..... @5@
      Fixed point debugging: ......... @6@
      Inline Assembly Optimizations: . @7@
      External Assembly Optimizations: @8@
      Intrinsics Optimizations.......: @9@
      Run-time CPU detection: ........ @10@
      Custom modes: .................. @11@
      Assertion checking: ............ @12@
      Fuzzing: ....................... @13@

      API documentation: ............. @14@
      Extra programs: ................ @15@
      Tests: ......................... @16@
------------------------------------------------------------------------

 Type "ninja; ninja install" to compile and install
 Type "ninja test" to run the test suite
'''.format(meson.project_version(), msg_c99_var_arrays, msg_c99_lrintf,
  msg_use_alloca, not opt_fixed_point, opt_float_approx,
  opt_fixed_point_debug, inline_optimization, asm_optimization,
  intrinsics_support, rtcd_support, opt_custom_modes,
  opt_assertions, opt_fuzzing, msg_doc,
  not disable_extra_programs, not disable_tests))
