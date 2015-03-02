package ru.serce.petooc;

import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.Label;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import static org.objectweb.asm.Opcodes.*;

/**
 * PETOOH Compiler
 *
 * @author Sergey Tselovalnikov
 * @since 14.12.14
 */
public class Petooc {

    public static int MAX_MEM = 32767;
    public static int level = 0;
    private List<List<String>> stack = new ArrayList<>();
    private MethodVisitor mv;

    public static final class Instructions {
        public static final String OP_INC = "Ko";
        public static final String OP_DEC = "kO";
        public static final String OP_INCPTR = "Kudah";
        public static final String OP_DECPTR = "kudah";
        public static final String OP_OUT = "Kukarek";
        public static final String OP_JMP = "Kud";
        public static final String OP_RET = "kud";
    }

    public static void main(String[] args) {
        if (args.length < 1) {
            printUsage();
            return;
        }
        String fileName = args[0];
        try (FileInputStream is = new FileInputStream(fileName)) {
            String classFileName = new File(fileName).getName();
            int dotIndex = classFileName.indexOf('.');
            if (dotIndex != -1) {
                classFileName = classFileName.substring(0, dotIndex);
            }
            Petooc petooc = new Petooc();
            petooc.compile(IOUtils.toString(is), classFileName);
        } catch (Exception e) {
            System.err.println("Compiler error: " + e.getMessage());
        }
    }

    private static void printUsage() {
        System.out.println("Usage: ./petooc test.koko");
    }

    public void compile(String program, String outFileName) {
        program = prepare(program);
        ClassWriter cw = new ClassWriter(0);
        cw.visit(49, ACC_PUBLIC + ACC_SUPER, outFileName, null, "java/lang/Object", null);

        {
            MethodVisitor cmv = cw.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);
            cmv.visitVarInsn(ALOAD, 0);
            cmv.visitMethodInsn(INVOKESPECIAL,
                    "java/lang/Object",
                    "<init>",
                    "()V");
            cmv.visitInsn(RETURN);
            cmv.visitMaxs(1, 1);
            cmv.visitEnd();
        }

        mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, "main", "([Ljava/lang/String;)V", null, null);
        // new array
        mv.visitIntInsn(Opcodes.SIPUSH, MAX_MEM);
        mv.visitIntInsn(NEWARRAY, T_INT);
        mv.visitIntInsn(ASTORE, 1);

        // i = 0
        mv.visitInsn(ICONST_0);
        mv.visitIntInsn(ISTORE, 2);


        char[] chars = program.toCharArray();
        StringBuilder instruction = new StringBuilder();
        for (int i = 0; i < chars.length; i++) {
            char c = chars[i];
            instruction.append(c);
            String buf = instruction.toString();
            if ((Instructions.OP_JMP.equals(buf) || Instructions.OP_RET.equals(buf)) &&
                    (i != chars.length - 1 && chars[i + 1] == 'a')) {
                continue;
            }
            switch (buf) {
                case Instructions.OP_INC:
                case Instructions.OP_DEC:
                case Instructions.OP_INCPTR:
                case Instructions.OP_OUT:
                case Instructions.OP_DECPTR:
                    if (level > 0) {
                        push(buf);
                    } else {
                        genbytecode(buf);
                    }
                    instruction = new StringBuilder();
                    break;
                case Instructions.OP_JMP:
                    level++;
                    if (stack.size() > level) {
                        stack.get(level).clear();
                    }
                    instruction = new StringBuilder();
                    break;
                case Instructions.OP_RET:
                    loop();
                    level--;
                    instruction = new StringBuilder();
                    break;
                default:
            }
        }
        mv.visitInsn(RETURN);
        mv.visitMaxs(1800, 1800);
        mv.visitEnd();
        save(cw.toByteArray(), outFileName);
    }

    private void incptr() {
        mv.visitIincInsn(2, 1);
    }

    private void decptr() {
        mv.visitIincInsn(2, -1);
    }

    private void dec() {
        mv.visitVarInsn(ALOAD, 1);
        mv.visitVarInsn(ILOAD, 2);
        mv.visitInsn(DUP2);
        mv.visitInsn(IALOAD);
        mv.visitInsn(ICONST_1);
        mv.visitInsn(ISUB);
        mv.visitInsn(IASTORE);
    }

    private void inc() {
        mv.visitVarInsn(ALOAD, 1);
        mv.visitVarInsn(ILOAD, 2);
        mv.visitInsn(DUP2);
        mv.visitInsn(IALOAD);
        mv.visitInsn(ICONST_1);
        mv.visitInsn(IADD);
        mv.visitInsn(IASTORE);
    }


    private void loop() {
        Label startLabel = new Label();
        mv.visitLabel(startLabel);
        mv.visitVarInsn(ALOAD, 1);
        mv.visitVarInsn(ILOAD, 2);
        mv.visitInsn(IALOAD);
        Label finishLabel = new Label();
        mv.visitJumpInsn(IFLE, finishLabel);
        for (String instr : stack.get(level)) {
            genbytecode(instr);
        }
        mv.visitJumpInsn(GOTO, startLabel);
        mv.visitLabel(finishLabel);
    }

    private void genbytecode(String buf) {
        switch (buf) {
            case Instructions.OP_INC:
                inc();
                return;
            case Instructions.OP_DEC:
                dec();
                return;
            case Instructions.OP_INCPTR:
                incptr();
                return;
            case Instructions.OP_DECPTR:
                decptr();
                return;
            case Instructions.OP_OUT:
                print();
            default:
        }
    }

    private void print() {
        mv.visitFieldInsn(GETSTATIC,
                "java/lang/System",
                "out",
                "Ljava/io/PrintStream;");
        mv.visitVarInsn(ALOAD, 1);
        mv.visitVarInsn(ILOAD, 2);
        mv.visitInsn(IALOAD);
        mv.visitMethodInsn(INVOKEVIRTUAL,
                "java/io/PrintStream",
                "print",
                "(C)V", false);
    }

    private void push(String buf) {
        while (stack.size() <= level) {
            stack.add(new ArrayList<String>());
        }
        stack.get(level).add(buf);
    }

    private void save(byte[] bytes, String outFileName) {
        String clazzFile = outFileName + ".class";
        try (OutputStream os = new BufferedOutputStream(new FileOutputStream(clazzFile))) {
            os.write(bytes);
            os.flush();
        } catch (Exception e) {
            System.err.println("Error saving class file: " + e.getMessage());
        }
    }

    private String prepare(String program) {
        return program.replaceAll("[^adehkKoOru]", "");
    }
}
