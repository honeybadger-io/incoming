# https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec)
module ControllerMacros
  def login_user
    let(:user) { Factory.create(:user) }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
  
  def it_should_require_user
    it { should set_the_flash }

    it "returns an error message" do
      flash[:alert].should include I18n.t('devise.failure.unauthenticated')
    end

    it { should respond_with(:redirect) }
  end
end