require 'test_helper'

class VendorReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vendor_review = vendor_reviews(:one)
  end

  test "should get index" do
    get vendor_reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_vendor_review_url
    assert_response :success
  end

  test "should create vendor_review" do
    assert_difference('VendorReview.count') do
      post vendor_reviews_url, params: { vendor_review: { body: @vendor_review.body, likes: @vendor_review.likes, title: @vendor_review.title, user_id: @vendor_review.user_id, vendor_address_line1: @vendor_review.vendor_address_line1, vendor_address_line2: @vendor_review.vendor_address_line2, vendor_contact_instructions: @vendor_review.vendor_contact_instructions, vendor_email_address: @vendor_review.vendor_email_address, vendor_name: @vendor_review.vendor_name, vendor_phone_number: @vendor_review.vendor_phone_number, vendor_services: @vendor_review.vendor_services } }
    end

    assert_redirected_to vendor_review_url(VendorReview.last)
  end

  test "should show vendor_review" do
    get vendor_review_url(@vendor_review)
    assert_response :success
  end

  test "should get edit" do
    get edit_vendor_review_url(@vendor_review)
    assert_response :success
  end

  test "should update vendor_review" do
    patch vendor_review_url(@vendor_review), params: { vendor_review: { body: @vendor_review.body, likes: @vendor_review.likes, title: @vendor_review.title, user_id: @vendor_review.user_id, vendor_address_line1: @vendor_review.vendor_address_line1, vendor_address_line2: @vendor_review.vendor_address_line2, vendor_contact_instructions: @vendor_review.vendor_contact_instructions, vendor_email_address: @vendor_review.vendor_email_address, vendor_name: @vendor_review.vendor_name, vendor_phone_number: @vendor_review.vendor_phone_number, vendor_services: @vendor_review.vendor_services } }
    assert_redirected_to vendor_review_url(@vendor_review)
  end

  test "should destroy vendor_review" do
    assert_difference('VendorReview.count', -1) do
      delete vendor_review_url(@vendor_review)
    end

    assert_redirected_to vendor_reviews_url
  end
end
