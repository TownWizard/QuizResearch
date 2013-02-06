    function validateEmpty(fld, filedName) {
        var error = "";
        var tfld = trim(fld.value)
        if (tfld.length == 0) {
            fld.style.background = 'Red';
            error = "Please fill in " + filedName + ". It is required.\n"
        } else {
            fld.style.background = 'White';
        }
        return error;
    }

    function trim(s)
    {
      return s.replace(/^\s+|\s+$/, '');
    }

    function validateEmail(fld, filedName) {
        var error="";
        error = validateEmpty(fld, filedName);
        if (error == ""){
          var emailFilter = /^[^\s()<>@,;:\/]+@\w[\w\.-]+\.[a-z]{2,}$/i;

          if (!emailFilter.test(fld.value)) {
              fld.style.background = 'Red';
              error = "Please enter a valid email address.\n";
          } else {
              fld.style.background = 'White';
          }
        }
        return error;
    }

    function validateYear(fld, min_age, filedName) {
        var error="";
        error = validateEmpty(fld, filedName);
        if (error == ""){
          var yearFilter = /^(19|20)[\d]{2,2}$/;
          currentDate = new Date();

          if (!yearFilter.test(fld.value)) {
                fld.style.background = 'Red';
                error = "Please enter a valid email address.\n";
            } else if (currentDate.getFullYear() - (parseInt(fld.value) + min_age) < 0) {
              fld.style.background = 'Red';
              error = "You must be " + min_age + " or over to take this survey.\n";
          } else {
              fld.style.background = 'White';
          }
        }
        return error;
    }
