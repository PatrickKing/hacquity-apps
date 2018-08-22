require "application_system_test_case"

class VendorReviewsTest < ApplicationSystemTestCase
  setup do
    @vendor_review = vendor_reviews(:one)
  end

  test "visiting the index" do
    visit vendor_reviews_url
    assert_selector "h1", text: "Vendor Reviews"
  end

  test "creating a Vendor review" do
    visit vendor_reviews_url
    click_on "New Vendor Review"

    fill_in "Body", with: @vendor_review.body
    fill_in "Likes", with: @vendor_review.likes
    fill_in "Title", with: @vendor_review.title
    fill_in "User", with: @vendor_review.user_id
    fill_in "Vendor Address Line1", with: @vendor_review.vendor_address_line1
    fill_in "Vendor Address Line2", with: @vendor_review.vendor_address_line2
    fill_in "Vendor Contact Instructions", with: @vendor_review.vendor_contact_instructions
    fill_in "Vendor Email Address", with: @vendor_review.vendor_email_address
    fill_in "Vendor Name", with: @vendor_review.vendor_name
    fill_in "Vendor Phone Number", with: @vendor_review.vendor_phone_number
    fill_in "Vendor Services", with: @vendor_review.vendor_services
    click_on "Create Vendor review"

    assert_text "Vendor review was successfully created"
    click_on "Back"
  end

  test "updating a Vendor review" do
    visit vendor_reviews_url
    click_on "Edit", match: :first

    fill_in "Body", with: @vendor_review.body
    fill_in "Likes", with: @vendor_review.likes
    fill_in "Title", with: @vendor_review.title
    fill_in "User", with: @vendor_review.user_id
    fill_in "Vendor Address Line1", with: @vendor_review.vendor_address_line1
    fill_in "Vendor Address Line2", with: @vendor_review.vendor_address_line2
    fill_in "Vendor Contact Instructions", with: @vendor_review.vendor_contact_instructions
    fill_in "Vendor Email Address", with: @vendor_review.vendor_email_address
    fill_in "Vendor Name", with: @vendor_review.vendor_name
    fill_in "Vendor Phone Number", with: @vendor_review.vendor_phone_number
    fill_in "Vendor Services", with: @vendor_review.vendor_services
    click_on "Update Vendor review"

    assert_text "Vendor review was successfully updated"
    click_on "Back"
  end

  test "destroying a Vendor review" do
    visit vendor_reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vendor review was successfully destroyed"
  end
end
