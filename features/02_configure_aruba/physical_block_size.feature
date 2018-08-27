Feature: Configure the phsical block size of disk

  As a developer
  I want to configure the physical block size
  In order to make the disk usage work for my application's setup

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.physical_block_size}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "512"
    """

  Scenario: Set the block size to something else which is a power of two
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      # use current working directory
      config.physical_block_size = 4096
    end

    Aruba.configure do |config|
      puts %(The default value is "#{config.physical_block_size}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "4096"
    """

  Scenario: The value needs to be a power of two, otherwise it will fail
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.physical_block_size = 3
    end
    """
    When I run `cucumber`
    Then the output should contain:
    """
    Contract violation for argument
    """
    
