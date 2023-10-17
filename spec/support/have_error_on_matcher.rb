RSpec::Matchers.define :have_error_on do |attribute|
  match do |actual|
    !actual.errors[attribute].empty?
  end
end
