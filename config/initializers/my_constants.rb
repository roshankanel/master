# Constant PASSWORD_REGEXPSTR stores password constraints
# Need 3 out of 4 groups: A-Z, a-z, 0-9, or symbols from !@#$%^&*()
# %r{...}x is used instead of /.../x so it does not look like a comment
# https://github.com/bbatsov/ruby-style-guide#regular-expressions
# the ||= syntax is equivalent to "unless const_defined?(:FOO)"
PASSWORD_REGEXPSTR ||= %r{
  (?=.*\d)(?=.*[a-z])(?=.*[A-Z])|
  (?=.*\d)(?=.*[a-z])(?=.*[!@#$%^&*()])|
  (?=.*\d)(?=.*[A-Z])(?=.*[!@#$%^&*()])|
  (?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()])
}x
#
EXPIRE_PASSWORD_AFTER = 180.days   # policy is 180 days
