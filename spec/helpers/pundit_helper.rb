module PunditHelper
  def stub_policy(policy)
    policy.any_instance.stub(:show?) { true }
    policy.any_instance.stub(:create?) { true }
    policy.any_instance.stub(:update?) { true }
    policy.any_instance.stub(:destroy?) { true }
  end
end