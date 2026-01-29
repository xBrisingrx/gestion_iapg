class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1 or /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.json { render json: { status: "success", msg: "Factura generada" }, status: :created }
        format.html { redirect_to @invoice, notice: "Invoice was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@invoice,
              partial: "invoices/invoice",
              locals: { invoice: @invoice }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Pago registrado.", status_class: "primary" })
          ]
        }
        format.html { redirect_to invoice_url(@invoice), notice: "Pago registrado." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_path, status: :see_other, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def generate_pdf
    invoice_items = InvoiceItem.where(invoice_id: params[:id])
    invoice = Invoice.find(params[:id])
    pdf = Prawn::Document.new
    pdf.font "Helvetica"
    pdf.text "Factura X", align: :center, size: 24
    pdf.image Rails.root.join("app/assets/images/logo.png")
    pdf.move_down 5
    pdf.text "Razon social: #{invoice.company.name}                  CUIT: #{invoice.company.cuit}", align: :left, size: 12
    table_data = [["Nombre y apellido", "Fecha", "Modulo","Sede", "Valor"]] +
                      invoice_items.map { |u| [u.person.fullname, u.course_person.date.strftime("%d-%m-%y"), u.course_person.unit.name,u.course.room.headquarter.name, "$#{u.course_person.price}.00"] }
    pdf.move_down 12
    pdf.table(table_data, header: true, width: pdf.bounds.width) do
      row(0).font_style = :bold
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.cell_style = { borders: [:top, :bottom, :left, :right], padding: 5 }
    end
    pdf.move_down 10
    pdf.text "TOTAL: $#{invoice.total}.00", align: :right, size: 12
    pdf.render_file("public/invoice.pdf")
    send_file(Rails.root.join("public/invoice.pdf"), filename: "filename", type: "application/pdf", disposition: "attachment")
  end

  def create_pdf_from(collection, column_names)
    headers = column_names.map { |header| "<font size='12'><b>#{header}</b></font>" }
    attributes = collection.pluck(column_names)

    pdf = Prawn::Document.new
    # The title of the document is the name of the model
    pdf.text collection.klass.name.humanize, align: :center, size: 24

    pdf.table([headers, *attributes], width: pdf.bounds.width, header: true,
              cell_style: {
                borders: %i[top bottom left right], padding: 5,
                size: 10,
                inline_format: true
              })

    pdf.move_down 10
    pdf.text "Rendered #{collection.size} records", align: :right, size: 12
    pdf
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:number, :company_id, :status, :detail, :date, :pay_date, :active,
                    invoice_items_attributes: [:id, :invoice, :course_person_id])
      # params.expect(invoice: [ :number, :company_id, :status, :detail, :date, :pay_date, :active,
      #               invoice_items_attributes: [:id, :invoice, :course_person_id] ])
    end
end
