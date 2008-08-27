require "rubygems"

require 'test/unit'

require 'active_support'
require 'action_pack'
require 'action_controller'
require 'action_view'

require 'ostruct'

require File.join(File.dirname(__FILE__), '../lib/annotated_timeline.rb')
include AnnotatedTimeline

require File.dirname(__FILE__) + '/test_helper.rb'

class AnnotatedTimelineTest < Test::Unit::TestCase
  # Replace this with your real tests.
  
  #'Sun Aug 24 17:06:15 -0400 2008' 'Sun Aug 26 17:06:15 -0400 2008' 'Sun Aug 28 17:06:15 -0400 2008'
  
  def test_this_plugin
    # @timestamp1= OpenStruct.new(:year => '2008')
    # @timestamp2= OpenStruct.new(:year => '2008')
    # @timestamp3= OpenStruct.new(:year => '2008')
    
    output = annotated_timeline({Time.now =>{:foo=>7, :bar=>9}, 1.days.ago=>{:foo=>6, :bar=>10}, 2.days.ago=>{:foo=>5, :bar=>4}})
    assert_match(/data\.addColumn\('date', 'Date'\);/, output, "Should Make Date Column")
    assert_match(/data\.addColumn\('number', 'Bar'\);/, output, "Should Make Bar Column")
    assert_match(/data\.addColumn\('number', 'Foo'\);/, output, "Should Make Foo Column")
  end
    # 
    # def time_ext_stub
    #    
    # end
  
  
end
