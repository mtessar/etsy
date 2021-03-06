require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ResponseTest < Test::Unit::TestCase

    context "An instance of the Response class" do
      
      should "be able to decode the JSON data to a hash" do
        data = '{ "foo":"bar" }'
        
        r = Response.new(data)
        r.to_hash.should == {'foo' => 'bar'}
      end
      
      should "only decode the JSON data once" do
        JSON.expects(:parse).once.returns({})
        
        r = Response.new('{ "foo":"bar" }')
        2.times { r.to_hash }
      end
      
      should "have a record count" do
        r = Response.new('')
        r.expects(:to_hash).with().returns('count' => 1)
        
        r.count.should == 1
      end
      
      should "return an array if there are multiple results entries" do
        r = Response.new('')
        r.expects(:count).with().returns(2)
        r.expects(:to_hash).with().returns('results' => %w(one two))
        
        r.result.should == %w(one two)
      end
      
      should "return a single value for results if there is only 1 result" do
        r = Response.new('')
        r.expects(:count).with().returns(1)
        r.expects(:to_hash).with().returns('results' => ['foo'])
        
        r.result.should == 'foo'
      end
      
    end


  end
end