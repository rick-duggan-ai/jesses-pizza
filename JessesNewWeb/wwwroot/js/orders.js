
let currentNumber = "";
let currentTransId = "";

function clickIt(phoneNumber, transactionId) {
    currentNumber = phoneNumber;
    currentTransId = transactionId;
    $('#pickTime').show();
    let now = new Date();
    let hour = now.getHours();
    let minute = now.getMinutes() + 45;
    if (minute > 60) {
        hour++;
        if (hour == 24) {
            hour = 0;
        }
        minute -= 60;
    }
    if (hour > 12) {
        document.getElementById("am").checked = false;
        document.getElementById("pm").checked = true;
        hour -= 12;
    }
    document.getElementById("hour").value = hour;
    document.getElementById("minute").value = (minute < 10) ? "0" + minute : minute;
}

function sendText() {
    let d = (document.getElementById("delivery").checked) ? "delivered" : "ready for pickup";
    let h = document.getElementById("hour").value;
    let m = document.getElementById("minute").value;
    if (m.length < 2) { m = "0" + m; }
    let a = (document.getElementById("am").checked) ? "AM" : "PM";
    let t = `${h}:${m} ${a}`
    let msg = `Your order from Jesse's Pizza will be ${d} at approximately ${t}`;
    let confirmationMsg = `message: ${msg} will be sent to ${currentNumber} for converge transaction id ${currentTransId}`;
    if (confirm(confirmationMsg)) {
        $.ajax({
            url: "/Send/Post",
            type: "POST",
            data: JSON.stringify({ "convergeTransactionId": currentTransId, "phoneNumber": currentNumber, "message": msg }),
            contentType: 'application/json',
            success: function () {
                sendSucceeded(currentTransId);
            },
            failure: sendFailed
        });
    } else {
        $('#pickTime').hide();
    }
}

function sendSucceeded(transId) {
    // alert('send succeeded ' + phoneNumber);
    r = document.getElementById("row_" + transId);
    if (r && r.parentNode) { r.parentNode.removeChild(r); }
}

function sendFailed() {
    alert("send failed to " + currentNumber);
}