import axios from 'axios';

const API_URL = 'http://localhost:5000/auth'; // Adjust port/path if needed. Based on package.json/server.js
// package.json says "start": "node build/server.js", port is usually 5000 or from env.
// User context showed active document in `src`, I assume 5000 from previous conversions or standard practice.
// Let's assume 5000.

const testAuth = async () => {
    try {
        const phone = "1234567890";
        // 1. Register User (Normal)
        console.log("\n1. Testing Registration...");
        try {
            const regResponse = await axios.post(`${API_URL}/register`, {
                name: "Test User",
                fatherName: "Father",
                surname: "Surname",
                // email: "test@example.com", // Optional now
                phoneNumber: phone,
                whatsappNumber: phone,
                birthDate: "1990-01-01",
                gender: "male",
                hrNo: "HR123",
                currentCity: "Test City",
                addresses: [{
                    address: "123 St",
                    city: "City",
                    district: "Dist",
                    state: "State",
                    country: "Country",
                    pincode: "123456",
                    type: "current"
                }],
                occupation: "Engineer",
                professions: ["Dev"],
                education: ["BTech"],
                maritalStatus: "Single",
                bloodGroup: "O+",
                class10: { class: "10", isStudded: false },
                class12: { class: "12", isStudded: false }
            });
            console.log("Registration Success:", regResponse.data.message);
        } catch (error: any) {
            if (error.response?.data?.message === "Email already exists" || error.response?.data?.message?.includes("duplicate")) {
                console.log("User might already exist, proceeding to login...");
            } else {
                console.error("Registration Failed:", error.response?.data || error.message);
            }
        }


        // 2. Send OTP
        console.log("\n2. Testing Send OTP...");
        let otp = "";
        try {
            const sendOtpRes = await axios.post(`${API_URL}/send-otp`, {
                phoneNumber: phone
            });
            console.log("Send OTP Success:", sendOtpRes.data.message);
            otp = sendOtpRes.data.data.otp; // Capture mock OTP
            console.log("Captured OTP:", otp);
        } catch (error: any) {
            console.error("Send OTP Failed:", error.response?.data || error.message);
            return;
        }

        // 3. Verify OTP & Login
        console.log("\n3. Testing Verify OTP (Login)...");
        try {
            const verifyRes = await axios.post(`${API_URL}/verify-otp`, {
                phoneNumber: phone,
                otp: otp.toString()
            });
            console.log("Verify OTP Success:", verifyRes.data.message);
            if (verifyRes.data.data.token) {
                console.log("Token received!");
            } else {
                console.error("No token in response!");
            }
        } catch (error: any) {
            console.error("Verify OTP Failed:", error.response?.data || error.message);
        }

    } catch (error) {
        console.error("Unexpected error:", error);
    }
};

testAuth();
