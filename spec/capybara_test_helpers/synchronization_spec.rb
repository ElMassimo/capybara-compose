# frozen_string_literal: true

RSpec.describe CapybaraTestHelpers::Synchronization do
  let(:session) do
    Capybara::Session.new(:rack_test, ->(_env) {
      [200, { 'Content-Type' => 'text/html' }, ['<button type="button">Save</button>']]
    })
  end
  let(:helper) { Capybara::TestHelper.new(session) }
  let(:driver_error) { Class.new(StandardError) }

  before do
    allow(Capybara).to receive(:current_session).and_return(session)
    allow(session.driver).to receive_messages(wait?: true, invalid_element_errors: [driver_error])
    allow(session.document).to receive(:sleep)
    clock = 0
    allow(Capybara::Helpers).to receive(:monotonic_time) { clock += 0.25 }
    allow(Capybara::Helpers).to receive(:timer).and_call_original
  end

  it 'retries transient errors supplied by the active driver' do
    calls = 0
    result = helper.send(:synchronize_expectation, wait: 1) do
      calls += 1
      raise driver_error if calls == 1

      :found
    end

    expect(result).to eq(:found)
    expect(calls).to eq(2)
    expect(session.document).to have_received(:sleep).once
  end

  it 'preserves missing-element and caller-supplied retries' do
    custom_error = Class.new(StandardError)
    failures = [Capybara::ElementNotFound, custom_error]
    result = helper.send(:synchronize_expectation, retry_on_errors: [custom_error], wait: 2) do
      error = failures.shift
      raise error if error

      :found
    end

    expect(result).to eq(:found)
    expect(session.document).to have_received(:sleep).twice
  end

  it 'retries RSpec failures and re-raises the original failure on timeout' do
    failure = RSpec::Expectations::ExpectationNotMetError.new('not ready')
    calls = 0
    result = helper.send(:synchronize_expectation, wait: 1) do
      calls += 1
      raise failure if calls == 1

      :ready
    end
    expect(result).to eq(:ready)
    expect(calls).to eq(2)

    expect {
      helper.send(:synchronize_expectation, wait: 0) { raise failure }
    }.to raise_error(failure)
  end

  it 'runs a successful assertion once without sleeping' do
    calls = 0
    result = helper.send(:synchronize_expectation) { calls += 1 }

    expect(result).to eq(1)
    expect(calls).to eq(1)
    expect(session.document).not_to have_received(:sleep)
  end

  it 'does not retry unrelated exceptions' do
    expect {
      helper.send(:synchronize_expectation) { raise ArgumentError, 'invalid input' }
    }.to raise_error(ArgumentError, 'invalid input')

    expect(session.document).not_to have_received(:sleep)
  end

  it 'does not retry driver errors when wait is zero' do
    calls = 0
    expect {
      helper.send(:synchronize_expectation, wait: 0) do
        calls += 1
        raise driver_error
      end
    }.to raise_error(driver_error)

    expect(calls).to eq(1)
    expect(session.document).not_to have_received(:sleep)
  end

  it 'retries driver errors within a single caller-supplied budget' do
    expect {
      helper.send(:synchronize_expectation, wait: 1) { raise driver_error }
    }.to raise_error(driver_error)

    expect(session.document).to have_received(:sleep).once
    expect(Capybara::Helpers).to have_received(:timer).with(expire_in: 1).once
    expect(Capybara::Helpers).to have_received(:timer).once
  end

  it 'reloads a stale scoped helper root' do
    session.visit('/')
    root = session.find('button')
    stale_base = root.base
    scoped_helper = Capybara::TestHelper.new(root)
    allow(root).to receive(:sleep)
    allow(stale_base).to receive(:all_text).and_raise(driver_error)

    scoped_helper.send(:synchronize_expectation, wait: 1) { expect(scoped_helper.text(:all)).to eq('Save') }

    expect(root.base).not_to equal(stale_base)
    expect(root).to have_received(:sleep).once
    expect(session.document).not_to have_received(:sleep)
  end
end
