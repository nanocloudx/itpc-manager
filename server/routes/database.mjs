import uuidv4 from 'uuid/v4'

export default {
  /**
   * findAll
   * @param schema
   * @returns {*|Promise<Array<Model>>}
   */
  findAll: (schema) => schema.findAll(),

  /**
   * findById
   * @param schema
   * @param id
   * @returns {*|Promise<Model>}
   */
  findById: (schema, id) => schema.findById(id),

  /**
   * create
   * @param schema
   * @param context
   * @returns {*}
   */
  create: (schema, context) => schema.create(Object.assign({ id: uuidv4() }, context)),

  /**
   * update
   * @param schema
   * @param id
   * @param context
   * @returns {*}
   */
  update: (schema, id, context) => schema.update(context, { where: { id } }),

  /**
   * destroy
   * @param schema
   * @param id
   * @returns {*}
   */
  destroy: (schema, id) => schema.destroy({ where: { id } })
}
