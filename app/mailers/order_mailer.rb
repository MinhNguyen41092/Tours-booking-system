class OrderMailer < ApplicationMailer

  def received order
    @order = order

    mail to: order.email, subject: t("mail.received")
  end

  def paid order
    @order = order

    mail to: order.email, subject: t("mail.paid")
  end

  def canceled order
    @order = order

    mail to: order.email, subject: t("mail.canceled")
  end
end
