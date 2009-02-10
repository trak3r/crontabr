#!/opt/local/bin/ruby

require 'test/unit'
require 'active_support/callbacks'
require 'active_support/test_case'
require 'crontabr'

class CrontabrTest < ActiveSupport::TestCase
  def test_scheduling
    job = "0 1 2 * * echo 'hello world'"
    job_id = 'xyzzy'
    Crontabr.unschedule job_id # start with a clean slate
    assert ! Crontabr.scheduled?(job_id)
    Crontabr.schedule job_id, job
    assert Crontabr.scheduled?(job_id)
    changed_job = "0 1 2 * * echo 'goodbye cruel world'"
    Crontabr.schedule job_id, changed_job
    assert Crontabr.scheduled?(job_id)
    Crontabr.unschedule job_id
    assert ! Crontabr.scheduled?(job_id)
  end
end