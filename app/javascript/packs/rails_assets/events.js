import * as $ from 'jquery'
require('jquery-datetimepicker/build/jquery.datetimepicker.full.min')

document.addEventListener('DOMContentLoaded', () => {

   $('.datepicker-for-edit').datetimepicker({
      minDate: '0',
      formatDate: 'Y/m/d',
      formatTime: 'H:i',
      format: 'Y/m/d H:i'
   })
   $.datetimepicker.setLocale('ja')
})