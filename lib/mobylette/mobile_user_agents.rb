module Mobylette

  # This is a mobile_user_agents object, you may pass your own implementation of this
  # to the mobylette_config, it must return respond to call, returning a regexp
  # for matching mobile user agents.
  #
  #   mobylette_config do |config|
  #     config[:mobile_user_agents] = proc { /iphone|android/ }
  #   end
  #
  class MobileUserAgents
    
    # Returns a list of mobile user agents
    #
    def call()
      Regexp.union(DEFAULT_USER_AGENTS)
    end

    # List of all mobile user agents
    #
    DEFAULT_USER_AGENTS = %w(
      palm
      blackberry
      nokia
      phone
      midp
      mobi
      symbian
      chtml
      ericsson
      minimo
      audiovox
      motorola
      samsung
      telit
      upg1
      windows\ ce
      ucweb
      astel
      plucker
      x320
      x240
      j2me
      sgh
      portable
      sprint
      docomo
      kddi
      softbank
      android
      mmp
      pdxgw
      netfront
      xiino
      vodafone
      portalmmm
      sagem
      mot-
      sie-
      ipod
      up.b
      webos
      amoi
      novarra
      cdm
      alcatel
      pocket
      ipad
      iphone
      mobileexplorer
      mobile
      maemo
      fennec
      silk
      playbook
    )
  end
end
