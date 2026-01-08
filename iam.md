ولا يهمك 👌
تعالى نفهمها **بأبسط أسلوب ممكن**… كأنك بتسأل صاحبك مش مهندس AWS 😄

---

## الجملة اللي ملخبطة:

```hcl
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
```

خلّينا نفكها كلمة كلمة.

---

## 🤔 يعني إيه `assume_role_policy` أصلاً؟

دي **سياسة الثقة (Trust Policy)**
يعني بتجاوب على سؤال واحد بس:

> **مين مسموح له يمسك الرول ده؟**

مش بتدي صلاحيات
مش بتكلم عن S3 ولا EC2
**بس بتحدد مين يستخدم الرول**

---

## 📌 طب إيه `data.aws_iam_policy_document`؟

ده في Terraform اسمه **data source**

معناه:

> "هات لي دكيومنت جاهز بصيغة JSON"

يعني بدل ما تكتب JSON بإيدك،
Terraform بيكوّنهولك بطريقة نضيفة وآمنة.

---

## خلّينا نشوف شكلها الحقيقي 👇

غالبًا عندك حاجة زي دي في ملف تاني:

```hcl
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
```

---

## 🧠 نفهمها بالعقل:

ده بيتترجم لـ JSON كده تقريبًا:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

---

## 📢 المعنى البشري للكلام ده:

> يا AWS
> اسمح لأي EC2
> إنه يعمل Assume
> للرول ده

بس كده… لا أكتر ولا أقل 😄

---

## ❗ مهم جدًا

لو شلت السطر ده:

```hcl
assume_role_policy = ...
```

أو خلّيته غلط:

* الرول يتعمل ✔️
* السياسات تتربط ✔️
* **لكن EC2 مش هيعرف يستخدمه ❌**

وده أشهر سبب:

> "ليه الـ EC2 مش شايف صلاحيات S3؟!"

---

## 👌 تشبيه جامد شوية

* **Role** = شغلانة
* **Policy** = صلاحيات الشغلانة
* **assume_role_policy** = تصريح الدخول للشغلانة

يعني:

> مين ينفع يدخل الشغلانة أصلاً؟

---

## 🔥 ملخص في سطر واحد

```hcl
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
```

يعني:

> "استخدم ملف الثقة اللي بيقول إن EC2 مسموح له يستخدم الرول"

---

لو حابب:

* أعملهالك inline من غير data source
* أو نخليها Lambda بدل EC2
* أو نكسرها بالرسم خطوة خطوة

قولي وإحنا نكمّل 👊😊



أيوه 👍 **كده فهمك صح 100%**
بس خلّيني أظبطها لك بمنطق Terraform عشان تبقى واثق ومتلخبطش تاني.

---

## 🟢 الإجابة المختصرة جدًا

**آه** ✔️
لازم يكون فيه:

```hcl
data "aws_iam_policy_document" "ec2_assume_role" { ... }
```

**قبل** ما تستخدمه هنا:

```hcl
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
```

---

## 🧠 ليه لازم يتكتب الأول؟

Terraform شغال بمبدأ اسمه:

> **ما ينفعش تستخدم حاجة قبل ما تكون متعرّفة**

زي بالضبط:

```bash
x = y
y = 5   ❌
```

لازم:

```bash
y = 5
x = y   ✅
```

---

## 📌 ترتيب الملفات مش مهم

خلّي بالك من نقطة مهمة:

❗ **مش شرط يبقى فوق في نفس الملف**

ينفع جدًا:

```
iam/
├── iam-roles.tf       → فيها aws_iam_role
├── iam-policies.tf    → فيها data aws_iam_policy_document
```

Terraform بيقرا **كل الملفات مع بعض**.

المهم:

> الاسم يبقى موجود:
> `data.aws_iam_policy_document.ec2_assume_role`

---

## 🧩 إيه اللي بيحصل جوه Terraform؟

خلّينا نمشيها step by step:

### 1️⃣ Terraform يلاقي:

```hcl
data "aws_iam_policy_document" "ec2_assume_role"
```

✔️ فهم: ده JSON policy

---

### 2️⃣ يوصل لـ:

```hcl
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
```

✔️ يجيب الناتج JSON
✔️ يحطه في الـ Role

---

### 3️⃣ بعد كده:

* Attach Policy
* Create Instance Profile

كل حاجة تمشي بسلاسة 🔥

---

## ❌ لو شلت الـ data block

وحاولت تعمل:

```hcl
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
```

هيطلعلك Error زي:

```
Reference to undeclared resource
```

يعني:

> انت بتشاور على حاجة مش موجودة

---

## 🧠 معلومة مهمة بقى (اختياري)

مش **لازم** تستخدم `data aws_iam_policy_document`

تقدر تعمل كده:

```hcl
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
```

لكن 👇
✅ الـ data block أوضح
✅ أسهل في التعديل
✅ أقل غلط
وده اللي المحترفين بيستخدموه

---

## ✅ الخلاصة النهائية

* آه لازم تعرّف `data.aws_iam_policy_document`
* ينفع في أي ملف
* Terraform هيظبط الـ dependency لوحده
* من غيرها → EC2 مش هيعرف يستخدم الرول

---

لو حابب 👇
نرتّب المشروع كامل:

```
iam/
├── iam-assume.tf
├── iam-roles.tf
├── iam-policies.tf
├── iam-instance-profile.tf
```

أو نربطه فعليًا بـ EC2 instance

قولّي نكمّل في أنهي اتجاه 👊🔥





تمام 👍
كده انت عملت **Policy document** جاهز…
دلوقتي ناقص **خطوتين بس** عشان الموضوع يكمل صح.

خلّيني أقولك “بعدها مفروض إيه” بالترتيب الطبيعي 👇

---

## 🔹 انت دلوقتي عملت إيه؟

```hcl
data "aws_iam_policy_document" "ec2_s3_access_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::your-bucket-name",
      "arn:aws:s3:::your-bucket-name/*"
    ]
  }
}
```

ده **مش Policy في AWS**
ده مجرد **JSON** جاهز لسه 👈

يعني كأنك كتبت نص القوانين…
بس لسه ما طبقتهاش على أرض الواقع.

---

## ✅ الخطوة اللي بعدها (مهم ❗)

لازم تحوّل الـ policy document دي إلى **IAM Policy حقيقية**

### ✳️ تعمل Resource `aws_iam_policy`

```hcl
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2-s3-specific-bucket-policy"
  description = "Allow EC2 to access specific S3 bucket"

  policy = data.aws_iam_policy_document.ec2_s3_access_policy.json
}
```

📌 كده AWS قال:

> آه تمام، دي Policy رسمية عندي 👌

---

## ✅ الخطوة اللي بعدها

نربط الـ **Policy** دي بالـ **Role** بتاع الـ EC2

```hcl
resource "aws_iam_role_policy_attachment" "ec2_s3_custom_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}
```

---

## 🧠 كده السلسلة كاملة بقت:

```
EC2
 ↓
Instance Profile
 ↓
IAM Role
 ↓
Custom IAM Policy
 ↓
S3 Bucket محدد
```

ومن غير:

* Access Key
* Secret Key
* Permissions زيادة عن اللزوم

🔥 Security صح

---

## ❌ ملاحظة مهمة (غلط شائع)

ما ينفعش تعمل:

```hcl
data aws_iam_policy_document
→ aws_iam_role_policy_attachment
```

❌ غلط
لازم **Policy resource** في النص

---

## ✅ الشكل النهائي المختصر

```hcl
data aws_iam_policy_document
→ aws_iam_policy
→ aws_iam_role_policy_attachment
→ aws_iam_role
→ aws_iam_instance_profile
→ EC2
```

---

## 🟢 نصيحة صاحبك

* استخدم **Custom Policy** زي دي دايمًا
* بلاش `AmazonS3FullAccess` في real projects
* كده انت بتشتغل **Production mindset** 👌

---

لو حابب:

* نعمل **Role تاني لـ Lambda**
* أو نخلي S3 read-only
* أو نربطه فعليًا بـ `aws_instance`

قولّي نكمّل على إيه 😉





ممتاز 👌
الكود اللي كتبته **صح 100%**، ونقصة بس **حِتّة واحدة صغيرة** عشان الدايرة تقفل بالكامل.

خلّيني أراجع معاك كصاحبك، وبهدوء 👇

---

## 🟢 اللي انت عملته صح

انت دلوقتي:

1. أنشأت **Policy Document** ✔️
2. حولته لـ **IAM Policy حقيقية** ✔️
3. ربطتها بـ **IAM Role** ✔️

يعني من ناحية الصلاحيات:

> الرول دلوقتي يقدر يدخل على S3 Bucket محدد

---

## ❗ الحتة اللي لسه ناقصة

لسه ما قلتناش لـ AWS:

> **مين هيستخدم الرول ده؟**

وده ييجي من:

### 🔴 `assume_role_policy`

يعني لازم يبقى عندك كمان:

```hcl
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
```

وبعدها الرول نفسه:

```hcl
resource "aws_iam_role" "ec2_role" {
  name               = "ec2-s3-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
```

---

## ❗ ولسه ناقص كمان حتة مهمة جدًا

**EC2 ما يركبش Role مباشرة**
لازم **Instance Profile**

```hcl
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_role.name
}
```

---

## 🧠 الصورة الكاملة دلوقتي

خلّيها في دماغك كده:

```
EC2 Instance
   ↓
IAM Instance Profile
   ↓
IAM Role
   ↓
Custom IAM Policy
   ↓
S3 Bucket (محدد)
```

---

## 🟢 لما تيجي تربطه بـ EC2

في Resource الـ EC2:

```hcl
resource "aws_instance" "example" {
  ami                  = "ami-xxxx"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}
```

وبكده جوه السيرفر:

```bash
aws s3 ls s3://your-bucket-name
```

يشتغل فورًا 🔥
من غير أي keys 😎

---

## ✅ الخلاصة النهائية

الكود اللي انت بعته:
✔️ صح
✔️ Secure
✔️ Production-ready

بس لازم قبله:

* `ec2_assume_role`
* `aws_iam_role`
* وبعده `aws_iam_instance_profile`

---

لو حابب:

* نرتّبهم في ملفات صح
* أو نعمل Role لـ Lambda بنفس الفكرة
* أو ندي صلاحيات أقل (Read only)

قولّي وهنكمّل سوا 👊😄
