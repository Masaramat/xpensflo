require "test_helper"

class DebitCreditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @debit_credit = debit_credits(:one)
  end

  test "should get index" do
    get debit_credits_url
    assert_response :success
  end

  test "should get new" do
    get new_debit_credit_url
    assert_response :success
  end

  test "should create debit_credit" do
    assert_difference("DebitCredit.count") do
      post debit_credits_url, params: { debit_credit: {  } }
    end

    assert_redirected_to debit_credit_url(DebitCredit.last)
  end

  test "should show debit_credit" do
    get debit_credit_url(@debit_credit)
    assert_response :success
  end

  test "should get edit" do
    get edit_debit_credit_url(@debit_credit)
    assert_response :success
  end

  test "should update debit_credit" do
    patch debit_credit_url(@debit_credit), params: { debit_credit: {  } }
    assert_redirected_to debit_credit_url(@debit_credit)
  end

  test "should destroy debit_credit" do
    assert_difference("DebitCredit.count", -1) do
      delete debit_credit_url(@debit_credit)
    end

    assert_redirected_to debit_credits_url
  end
end
