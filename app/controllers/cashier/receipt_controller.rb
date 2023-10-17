class Cashier::ReceiptController < Cashier::BaseController
  def index
    @receipt = nil
  end

  def validate
    @receipt = params[:receipt]
    md = @receipt.match(/-+([^-]+)-+\s*[^:]+: ([^-]+)-+/m)
    if md
      data = md[1].strip
      data_to_sign = data.split.join
      checksum = md[2].strip
      computed_checksum = Digest::SHA1.hexdigest(Settings.receipt_secret_key + data_to_sign)
      @valid = if checksum == computed_checksum
                 :valid
               else
                 :invalid
               end
    else
      @valid = :format_error
    end
    render 'index'
  end
end
