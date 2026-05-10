module Session
  def setting_session(rspec_session)
    session = defined?(rspec_session) ? rspec_session : {}
    # undefined method `enabled?を解消するために必要
    session.class_eval { def enabled? = false }
    # sessionメソッドを上書き
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(session) # rubocop:disable RSpec/AnyInstance
  end
end
