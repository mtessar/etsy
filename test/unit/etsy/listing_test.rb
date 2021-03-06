require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ListingTest < Test::Unit::TestCase

    context "The Listing class" do
      
      should "be able to find all listings by :user_id" do
        user_id = 122345
        
        response = mock_request_cycle :for => "/shops/#{user_id}/listings", :data => 'getShopListings'
        
        listing_1, listing_2 = response.result
        
        Listing.expects(:new).with(listing_1).returns('listing_1')
        Listing.expects(:new).with(listing_2).returns('listing_2')
        
        Listing.find_all_by_user_id(user_id).should == ['listing_1', 'listing_2']
      end
      
    end
    
    context "An instance of the Listing class" do

      when_populating Listing, :from => 'getShopListings' do

        value_for :id,          :is => 24165902
        value_for :state,       :is => 'active'
        value_for :title,       :is => 'hanging with the bad boys matchbox'
        value_for :description, :is => 'standard size matchbox ...'
        value_for :url,         :is => 'http://www.etsy.com/view_listing.php?listing_id=24165902'
        value_for :view_count,  :is => 18
        value_for :created,     :is => 1240673494.49
        value_for :price,       :is => 3
        value_for :quantity,    :is => 1
        value_for :currency,    :is => 'USD'
        value_for :ending,      :is => 1251214294.49
        value_for :tags,        :is => %w(accessories matchbox)
        value_for :materials,   :is => %w(standard_matchbox notebook_paper)
        
      end
      
      %w(active removed sold_out expired alchemy).each do |state|
        should "know that the listing is #{state}" do
          listing = Listing.new
          listing.expects(:state).with().returns(state.sub('_', ''))

          listing.send("#{state}?".to_sym).should be(true)
        end

        should "know that the listing is not #{state}" do
          listing = Listing.new
          listing.expects(:state).with().returns(state.reverse)

          listing.send("#{state}?".to_sym).should be(false)
        end        
      end
      
      should "know the create date" do
        listing = Listing.new
        listing.expects(:created).with().returns(1240673494.49)
        
        listing.created_at.should == Time.at(1240673494.49)
      end
      
      should "know the ending date" do
        listing = Listing.new
        listing.expects(:ending).with().returns(1240673494.49)
        
        listing.ending_at.should == Time.at(1240673494.49)
      end
      
      should "have associated images" do
        data = read_fixture('getShopListings')[0]
        listing = Listing.new(data)

        Image.expects(:new).with(data['all_images'][0]).returns('image_1')
        Image.expects(:new).with(data['all_images'][1]).returns('image_2')
        
        listing.images.should == ['image_1', 'image_2']
      end
      
      should "have a primary image" do
        listing = Listing.new
        listing.expects(:images).with().returns(%w(one two))
        
        listing.image.should == 'one'
      end
      
    end
  end
end