require 'test_helper'

class ConnectionRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @connection_request = connection_requests(:one)
  end

  test "should get index" do
    get connection_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_connection_request_url
    assert_response :success
  end

  test "should create connection_request" do
    assert_difference('ConnectionRequest.count') do
      post connection_requests_url, params: { connection_request: { connection_type: @connection_request.connection_type, initiator_id: @connection_request.initiator_id, initiator_service_posting_id: @connection_request.initiator_service_posting_id, initiator_status: @connection_request.initiator_status, receiver_id: @connection_request.receiver_id, receiver_service_posting_id: @connection_request.receiver_service_posting_id, receiver_status: @connection_request.receiver_status } }
    end

    assert_redirected_to connection_request_url(ConnectionRequest.last)
  end

  test "should show connection_request" do
    get connection_request_url(@connection_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_connection_request_url(@connection_request)
    assert_response :success
  end

  test "should update connection_request" do
    patch connection_request_url(@connection_request), params: { connection_request: { connection_type: @connection_request.connection_type, initiator_id: @connection_request.initiator_id, initiator_service_posting_id: @connection_request.initiator_service_posting_id, initiator_status: @connection_request.initiator_status, receiver_id: @connection_request.receiver_id, receiver_service_posting_id: @connection_request.receiver_service_posting_id, receiver_status: @connection_request.receiver_status } }
    assert_redirected_to connection_request_url(@connection_request)
  end

  test "should destroy connection_request" do
    assert_difference('ConnectionRequest.count', -1) do
      delete connection_request_url(@connection_request)
    end

    assert_redirected_to connection_requests_url
  end
end
