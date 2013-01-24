require 'retriable'
require 'calabash-android/operations' # for default_device.adb_command
# https://gist.github.com/4589830

def focused_activity
  `#{default_device.adb_command} shell dumpsys window windows`.each_line.grep(/mFocusedApp.+[\.\/]([^.\/\}]+)}/){$1}.first
end

def wait_for_activity activity
  retriable :tries => 15, :interval => 1 do
    focused = focused_activity
    raise "Activity #{activity} not found. Current activity is #{focused}" if focused != activity
  end
end