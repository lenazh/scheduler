# Stubs out the Pundit policies for controller tests so
# that they are not coupled with the authorization tests
module PunditHelper
  def stub_policy(policy)
    policy.any_instance.stub(:show?) { true }
    policy.any_instance.stub(:create?) { true }
    policy.any_instance.stub(:update?) { true }
    policy.any_instance.stub(:destroy?) { true }
  end
end
