class Sheet
  def self.for_bookings(bookings)
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', sz: 14, bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', sz: 14, fg_color: "000000"
    link = axlsx.workbook.styles.add_style font_name: 'Calibri', sz: 14, fg_color: "007896"

    axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row ["Bokningar för mobil försäljning i Malmö för #{bookings.first.company.name}."], style: body
      sheet.add_row ["https://mobilforsaljning.malmo.se/"], style: link
      sheet.add_hyperlink location: 'https://mobilforsaljning.malmo.se/', ref: sheet.rows[1].cells[0]
      sheet.add_row ["Utskriven #{Date.today.iso8601}"], style: body
      sheet.add_row

      sheet.add_row %w(
        Plats
        Dag
        Tid
      ), style: heading
      bookings.each do |booking|
        sheet.add_row([
          booking.place.name,
          booking.date.to_s,
          "#{booking.time_slot.from}–#{booking.time_slot.to}"
        ], style: body)
      end

      sheet.column_widths 20, 20, 20, 20
    end
    axlsx.to_stream.read
  end
end
