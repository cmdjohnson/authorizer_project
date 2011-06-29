# -*- encoding : utf-8 -*-
################################################################################
# This software was created by Daniel Wuck, copyright (c) 2011
################################################################################
# This software may not be reproduced in any form without explicit written permission from the author.
################################################################################
# Daniel Wuck
# Veenwal 130
# 3432ZE Nieuwegein
# The Netherlands
#
# daniel.wuck@gmail.com
################################################################################
# All used software is licensed by their respective authors.
################################################################################

class OptionsChecker
  def self.check options, mandatories
    raise "options argument must be a Hash" unless options.is_a?(Hash)
    raise "mandatories argument must be an Array" unless mandatories.is_a?(Array)

    for mandatory in mandatories
      raise "Argument #{mandatory} cannot be nil. You provided: #{options.inspect}" if options[mandatory].nil?
    end

    return options
  end
end

