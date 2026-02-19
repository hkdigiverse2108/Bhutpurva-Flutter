import jsonwebtoken from "jsonwebtoken";
import { userModel } from "../database/models";

export const generateToken = (id: string) => {
    return jsonwebtoken.sign({ id }, process.env.JWT_TOKEN_SECRET as string);
}

export const verifyToken = async (req, res, next) => {
    try {
        let token = req.headers.authorization;
        if (!token) return res.status(401).json({ message: "No token provided" });
        if (token.startsWith("Bearer ")) {
            token = token.slice(7, token.length).trim();
        }

        if (!token || token === "null" || token === "undefined") {
            return res.status(401).json({ message: "No token provided" });
        }
        const decodedToken = jsonwebtoken.verify(token, process.env.JWT_TOKEN_SECRET as string);

        const user = await userModel.findOne({ _id: decodedToken.id });
        if (!user) return res.status(410).json({ message: "User Not Found" });

        if (user.activeSessions) {
            const session = user.activeSessions.find((session) => session.token === token);
            if (!session) return res.status(410).json({ message: "Your session has expired Login again" });
        }

        req.headers.user = user;
        next();
    } catch (error: any) {
        if (error instanceof jsonwebtoken.JsonWebTokenError) {
            console.error("JWT Error:", error.message);
        } else {
            console.error(error);
        }
        return res.status(401).json({ message: "Unauthorized", error: error.message });
    }
}