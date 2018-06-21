require "application_system_test_case"

class ConnectionRequestsTest < ApplicationSystemTestCase
  setup do
    @connection_request = connection_requests(:one)
  end

  test "visiting the index" do
    visit connection_requests_url
    assert_selector "h1", text: "Connection Requests"
  end

  test "creating a Connection request" do
    visit connection_requests_url
    click_on "New Connection Request"

    fill_in "Connection Type", with: @connection_request.connection_type
    fill_in "Initiator", with: @connection_request.initiator_id
    fill_in "Initiator Service Posting", with: @connection_request.initiator_service_posting_id
    fill_in "Initiator Status", with: @connection_request.initiator_status
    fill_in "Receiver", with: @connection_request.receiver_id
    fill_in "Receiver Service Posting", with: @connection_request.receiver_service_posting_id
    fill_in "Receiver Status", with: @connection_request.receiver_status
    click_on "Create Connection request"

    assert_text "Connection request was successfully created"
    click_on "Back"
  end

  test "updating a Connection request" do
    visit connection_requests_url
    click_on "Edit", match: :first

    fill_in "Connection Type", with: @connection_request.connection_type
    fill_in "Initiator", with: @connection_request.initiator_id
    fill_in "Initiator Service Posting", with: @connection_request.initiator_service_posting_id
    fill_in "Initiator Status", with: @connection_request.initiator_status
    fill_in "Receiver", with: @connection_request.receiver_id
    fill_in "Receiver Service Posting", with: @connection_request.receiver_service_posting_id
    fill_in "Receiver Status", with: @connection_request.receiver_status
    click_on "Update Connection request"

    assert_text "Connection request was successfully updated"
    click_on "Back"
  end

  test "destroying a Connection request" do
    visit connection_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Connection request was successfully destroyed"
  end
end
