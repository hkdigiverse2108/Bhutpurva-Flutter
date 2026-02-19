import twilio from "twilio";

const client = twilio(
  process.env.TWILIO_ACCOUNT_SID!,
  process.env.TWILIO_AUTH_TOKEN!
);

export const sendSms = async (
  phoneNumber: string,
  message: string
): Promise<void> => {
  try {
    await client.messages.create({
      body: message,
      from: process.env.TWILIO_PHONE_NUMBER!,
      to: phoneNumber,
    });
  } catch (error: any) {
    console.error("SMS sending failed:", error.message);
    throw new Error("SMS_FAILED");
  }
};
