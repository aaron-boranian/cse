# Copyright (c) 1997-2016 The CSE Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file.
require('open3')

module Command
  # Run :: String (Array String) ?String -> String
  # Given a command (a String), an array of strings of options, and an optional
  # input string to feed into the program, return program's output, erroring if
  # the program errors
  Run = lambda do |cmd, opts, input=nil|
    opts_str = if opts.instance_of?("".class)
                 opts
               else
                 opts.join(' ')
               end
    cmd = "#{cmd} #{opts_str}"
    output = error = exit_status = nil
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      stdin.puts(input) if input
      stdin.close
      stdout.set_encoding('utf-8')
      output = stdout.read
      error = stderr.read
      exit_status = wait_thr.value
    end
    raise error unless exit_status.success?
    output
  end
end
