class FinancialReportsController < ApplicationController
  before_action :verify_admin
  before_action :load_financial_report, except: [:index, :new, :create]

  def index
    @financial_reports = FinancialReport.all.newest.page(params[:page])
      .per Settings.items_per_pages
  end

  def new
    @financial_report = FinancialReport.new
  end

  def create
    @financial_report = FinancialReport.new report_params
    @financial_report.financial_report = current_financial_report
    @financial_report.net_income = @financial_report.revenue - @financial_report.cost
    if @financial_report.save
      flash[:success] = t "reports.created"
      redirect_to @financial_report
    else
      render :new
    end
  end

  def edit; end

  def update
    if @financial_report.update report_params
      flash[:success] = t "reports.updated"
      redirect_to financial_reports_path
    else
      render :edit
    end
  end

  def destroy
    if @financial_report.destroy
      flash[:success] = t "reports.deleted"
    else
      flash[:danger] = t "reports.delete_failed"
    end
    redirect_to :back
  end

  private

  def load_financial_report
    @financial_report = FinancialReport.find_by id: params[:id]
    return if @financial_report
    flash[:danger] = t "reports.not_found"
    redirect_to root_path
  end

  def report_params
    params.require(:financial_report).permit :date, :cost, :revenue, :net_income
  end
end
