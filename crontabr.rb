require 'open3'

class Crontabr

  class << self
    
    def scheduled?(job_id)
      stdin, stdout, stderr = Open3.popen3('crontab -l')
      while(line = stdout.gets)
        return true if line.include?(tag(job_id))
      end
      return false
    end

    def schedule(job_id, job)
      jobs = [tagged(job_id, job)]
      stdin, stdout, stderr = Open3.popen3('crontab -l')
      while(line = stdout.gets)
        jobs << line unless line.include?(tag(job_id))
      end
      tabbem(jobs)
    end

    def unschedule(job_id)
      jobs = []
      stdin, stdout, stderr = Open3.popen3('crontab -l')
      while(line = stdout.gets)
        jobs << line unless line.include?(tag(job_id))
      end
      tabbem(jobs)
    end

    private

    def tabbem(jobs)
      stdin, stdout, stderr = Open3.popen3('crontab')
      jobs.each do |job|
        stdin.puts job
      end
      stdin.close
    end

    def tagged(job_id, job)
      "#{job} #{tag(job_id)}"
    end

    def tag(job_id)
      "# crontabr_#{job_id}"
    end

  end
end