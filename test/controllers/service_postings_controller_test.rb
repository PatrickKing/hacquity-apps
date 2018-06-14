require 'test_helper'

class ServicePostingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_posting = service_postings(:one)
  end

  test "should get index" do
    get service_postings_url
    assert_response :success
  end

  test "should get new" do
    get new_service_posting_url
    assert_response :success
  end

  test "should create service_posting" do
    assert_difference('ServicePosting.count') do
      post service_postings_url, params: { service_posting: { closed: @service_posting.closed, description: @service_posting.description, fullTimeEquivalents: @service_posting.fullTimeEquivalents, postingType: @service_posting.postingType, summary: @service_posting.summary, userId_id: @service_posting.userId_id } }
    end

    assert_redirected_to service_posting_url(ServicePosting.last)
  end

  test "should show service_posting" do
    get service_posting_url(@service_posting)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_posting_url(@service_posting)
    assert_response :success
  end

  test "should update service_posting" do
    patch service_posting_url(@service_posting), params: { service_posting: { closed: @service_posting.closed, description: @service_posting.description, fullTimeEquivalents: @service_posting.fullTimeEquivalents, postingType: @service_posting.postingType, summary: @service_posting.summary, userId_id: @service_posting.userId_id } }
    assert_redirected_to service_posting_url(@service_posting)
  end

  test "should destroy service_posting" do
    assert_difference('ServicePosting.count', -1) do
      delete service_posting_url(@service_posting)
    end

    assert_redirected_to service_postings_url
  end
end
