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

  def test_data_points_inserted
    output  = annotated_timeline({Time.now =>{:foo=>7}, 
                                  1.days.ago=>{:foo=>6, :bar=>10}, 
                                  2.days.ago=>{:bar=>4}, 
                                  3.days.ago=>{:foo=>6, :bar=>2}, 
                                  4.days.ago=>{:foo=>9, :bar=>7}})

    output2 = annotated_timeline({3.days.ago=>{:foo=>6, :bar=>2}, 
                                  Time.now =>{:foo=>7}, 
                                  2.days.ago=>{:bar=>4}, 
                                  1.days.ago=>{:foo=>6, :bar=>10}, 
                                  4.days.ago=>{:bar=>7, :foo=>9}})

    assert_match(/data\.addColumn\('date', 'Date'\);/, output, "Should Make Date Column")
    assert_match(/data\.addColumn\('number', 'Bar'\);/, output, "Should Make Bar Column")
    assert_match(/data\.addColumn\('number', 'Foo'\);/, output, "Should Make Foo Column")
    
    date_string = "data.setValue(0, 0, new Date(#{4.days.ago.year}, #{4.days.ago.month-1}, #{4.days.ago.day}));"
    assert_match(date_string, output, "should put the first date in properly")
    
    assert_match(/data\.setValue\(0, 1, 7\);/, output, "should put right value for bar" )
    assert_match(/data\.setValue\(0, 2, 9\);/, output, "should put right value for foo")
    
    assert_match(output, output2, "data should be sorted properly")
  end
  
  def test_options_passed
    output = annotated_timeline({Time.now =>{:foo=>7, :bar=>9}, 1.days.ago=>{:foo=>6, :bar=>10}, 2.days.ago=>{:foo=>5, :bar=>4}}, 300, 200, 'graph',
                                {:displayExactValues  =>  true, 
                                  :min                =>  5, 
                                  :scaleType          =>  'maximize',
                                  :colors             => ['orange', '#AAAAAA'],
                                  :zoomStartTime      => 4.days.ago})
    
    
    assert_match(/displayExactValues: true/, output, "should pass exact values option")
    assert_match(/min: 5/, output, "should pass min option")
    assert_match(/scaleType: maximize/, output, "should pass scale type options")
    assert_match(/colors: \[\"orange\", \"#AAAAAA\"\]/, output, "should pass colors")
    
    date_string = "zoomStartTime: new Date(#{4.days.ago.year}, #{4.days.ago.month-1}, #{4.days.ago.day})"
    assert_match(date_string, output, "should pass zoom option")
  
    assert_match("<div id=\"graph\" style=\"width: 300px\; height: 200px\;\"></div>", output)
  end
  
end