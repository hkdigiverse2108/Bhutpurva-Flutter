# Bhutpurva Backend - AI Copilot Instructions

## Project Overview

Express.js + TypeScript backend for a user management and batch/group organization system. MongoDB for persistence. Compiles to JavaScript in the `/build` directory.

## Architecture Patterns

### Request-Response Flow

All responses use the standardized `apiResponse` class ([src/common/apiRes.ts](src/common/apiRes.ts)):

```typescript
new apiResponse(statusCode, message, data, error);
```

Status codes are defined in [src/common/statusCode.ts](src/common/statusCode.ts) (SUCCESS: 200, BAD_REQUEST: 400, TOKEN_EXPIRED: 410, etc.)

### Controller Pattern

Controllers follow a consistent try-catch flow:

1. Validate input with Joi schemas from `/validation`
2. Call database helpers from `/helper/database-service.ts`
3. Return standardized `apiResponse`

Example: [src/controllers/batch/index.ts](src/controllers/batch/index.ts)

### Database Operations

All Mongoose operations are abstracted through helper functions in [src/helper/database-service.ts](src/helper/database-service.ts):

- `createData()` - Create new document
- `getData()`, `getFirstMatch()` - Query with lean=true (optimization)
- `updateData()`, `updateMany()` - Updates with new:true
- `findAllWithPopulate()`, `findOneAndPopulate()` - Reference population
- `aggregateData()` - Complex queries

Always use these helpers, not raw Mongoose calls.

### Validation

Use Joi schemas in `/validation` with conditional validation patterns (`.when()` for conditional required fields):

- [src/validation/authValidators.ts](src/validation/authValidators.ts) - User and address schemas
- [src/validation/batchValidators.ts](src/validation/batchValidators.ts)
- [src/validation/groupValidators.ts](src/validation/groupValidators.ts)

### Authentication & Authorization

- JWT tokens from [src/helper/jwt.ts](src/helper/jwt.ts)
- Token verification middleware in [src/routers/index.ts](src/routers/index.ts) - all routes after `/auth` are protected
- Role-based access in [src/helper/role.ts](src/helper/role.ts) (ROLES: admin, user, monitor)

### Enums & Constants

All application enums centralized in [src/common/enum.ts](src/common/enum.ts):

- GENDER, ADDRESS_TYPE, CLASS, ROLES, STATUS
- Reference these by importing from `"../../common"`

### Model References

Database models in [src/database/models/](src/database/models/):

- Models use MongoDB references with `populate()` for relationships
- Model names stored in [src/common/modelName.ts](src/common/modelName.ts) for consistency

## Build & Run

```bash
npm run build          # Compile TypeScript to ./build
npm run server         # Watch mode - auto-compile and restart on changes
npm start              # Run compiled build (production)
npm run clean          # Remove build directory
```

Environment variables from `.env`: `PORT`, `DB_URL`, JWT secrets in [src/helper/jwt.ts](src/helper/jwt.ts)

## Key Conventions

- **Soft Deletes**: Use `isDeleted: true` flag instead of hard deletion (see [src/controllers/batch/index.ts](src/controllers/batch/index.ts#L40))
- **Lean Queries**: Database helpers set `lean: true` for performance (returns plain objects, not Mongoose docs)
- **Error Handling**: Return standardized apiResponse with error object in catch blocks
- **Password Hashing**: Use bcryptjs before storing (see [src/controllers/auth/index.ts](src/controllers/auth/index.ts#L18))
- **Nested Schema Patterns**: For embedded objects like classDetailsSchema, define them as separate schemas reused in parent schemas

## Logging & Utilities

- Winston logger in [src/helper/winston-logger.ts](src/helper/winston-logger.ts)
- Email service: [src/helper/mail.ts](src/helper/mail.ts)
- Generic response messages: [src/helper/response.ts](src/helper/response.ts)

## When Adding Features

1. Create validation schema in `/validation` folder
2. Add controller endpoint in `/controllers` matching resource type
3. Use database helpers for all data access
4. Return apiResponse with appropriate STATUS_CODE
5. If new data model, add to `/database/models/` and export from index
