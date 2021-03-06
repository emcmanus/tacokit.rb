require "spec_helper"

describe Tacokit::Client::Actions do
  def test_action_id
    "548e3153ea7ca8f9cd3cb77b"
  end

  def test_card_id
    "548dd95c8ca25ac9d0d9ce71"
  end

  describe "#action", :vcr do
    it "returns a token authorized action" do
      action = app_client.action(test_action_id)

      expect(action.type).to be_present
      expect(action.data).to be_any
    end

    it "returns oauth authorized board" do
      action = oauth_client.action(test_action_id)

      expect(action.type).to be_present
      expect(action.data).to be_any
    end
  end

  describe "#action_board", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Get action resource test. Booya!")
    end

    it "returns action board" do
      board = app_client.action_board(@action.id)

      expect(board.name).to be_present
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#action_card", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Get action resource test. Booya!")
    end

    it "returns action card" do
      card = app_client.action_card(@action.id)

      expect(card.name).to be_present
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#action_entities", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Get action resource test. Booya!")
    end

    it "returns action entities" do
      entities = app_client.action_entities(@action.id)

      expect(entities).to be_any
      expect(entities.map(&:type)).to include("comment")
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#action_list", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Get action resource test. Booya!")
    end

    it "returns action list" do
      list = app_client.action_list(@action.id)

      expect(list.name).to be_present
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#update_action", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Update action test. Booya!")
    end

    it "updates an action" do
      action = app_client.update_action(@action.id, text: "@tacokit Thanks for the invite, bud")

      expect(action.data.text).to eq "@tacokit Thanks for the invite, bud"
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#update_action_text", :vcr do
    before do
      @action = app_client.add_comment test_card_id, "Update action test. Booya!"
    end

    it "updates an action" do
      action = app_client.update_action_text(@action.id, "@tacokit Thanks for the invite, bud")

      expect(action.data.text).to eq "@tacokit Thanks for the invite, bud"
    end

    after do
      app_client.delete_action(@action.id)
    end
  end

  describe "#delete_action", :vcr do
    before do
      @action = app_client.add_comment(test_card_id, "Delete action test. Booya!")
    end

    it "deletes an action" do
      app_client.delete_action(@action.id)

      assert_requested :delete, trello_url_template("actions/#{@action.id}{?key,token}")
      expect { app_client.action(@action.id) }.to raise_error(Tacokit::Error::ResourceNotFound)
    end
  end
end
