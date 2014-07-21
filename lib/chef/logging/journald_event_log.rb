require 'chef/logging/event_log'
require 'systemd-journal'

class Chef
    module Logging
        class JournaldEventLogger < Logging::EventLogger

            def run_start(version)
                Systemd::Journal::message(
                    :priority => Systemd::Journal::LOG_INFO,
                    :message => "Starting chef-client run",
                    :version => version) 
                # Runid is not available in this context
            end

            def run_started(run_status)
                @run_status = run_status
                Systemd::Journal::message(
                    :priority => Systemd::Journal::LOG_INFO,
                    :message => "Started chef-client run",
                    :runId => run_status.run_id) 
            end

            def run_completed(node)
                Systemd::Journal::message(
                    :priority => Systemd::Journal::LOG_INFO,
                    :message => "Completed chef-client run",
                    :runId => @run_status.run_id,
                    :elapsed => @run_status.elapsed_time) 
            end

            def run_failed(e)
                Systemd::Journal::message(
                    :priority => Systemd::Journal::LOG_ERR,
                    :message => "Failed chef-client run",
                    :exception_name => e.class.name,
                    :exception_msg => e.message,
                    :backtrace => e.backtrace.join("\n"),
                    :runId => @run_status.run_id,
                    :elapsed => @run_status.elapsed_time) 
            end
        end
    end
end
