export const roleCheck = (role: string[]) => {
    try {
        return (req: any, res: any, next: any) => {
            if (!req.headers.user || !role.includes(req.headers.user.role)) {
                return res.status(403).json({ message: "Forbidden" });
            }
            next();
        }
    } catch (error) {
        console.log(error);
    }
}